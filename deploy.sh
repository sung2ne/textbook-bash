#!/bin/bash
# deploy.sh: 원자적 배포 스크립트 (무중단 배포 + 자동 롤백)

set -euo pipefail

# ─── 설정 ─────────────────────────────────────────────────────────────────────
DEPLOY_HOST="${DEPLOY_HOST:-}"
DEPLOY_USER="${DEPLOY_USER:-deploy}"
DEPLOY_BASE="/var/www/myapp"
RELEASES_DIR="$DEPLOY_BASE/releases"
CURRENT_LINK="$DEPLOY_BASE/current"
SHARED_DIR="$DEPLOY_BASE/shared"
KEEP_RELEASES=5    # 유지할 이전 버전 수

APP_DIR=$(pwd)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RELEASE_DIR="$RELEASES_DIR/$TIMESTAMP"

# 컬러 출력
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()     { echo -e "${CYAN}[$(date '+%H:%M:%S')]${NC} $*"; }
success() { echo -e "${GREEN}[$(date '+%H:%M:%S')] ✓${NC} $*"; }
warn()    { echo -e "${YELLOW}[$(date '+%H:%M:%S')] !${NC} $*"; }
error()   { echo -e "${RED}[$(date '+%H:%M:%S')] ✗${NC} $*" >&2; }

# ─── 원격 실행 헬퍼 ───────────────────────────────────────────────────────────
remote() {
    if [ -n "$DEPLOY_HOST" ]; then
        ssh "$DEPLOY_USER@$DEPLOY_HOST" "$@"
    else
        # 로컬 배포 모드 (테스트용)
        bash -c "$@"
    fi
}

# ─── 롤백 함수 ────────────────────────────────────────────────────────────────
rollback() {
    local reason=$1
    error "배포 실패: $reason"
    warn "롤백을 시작합니다..."

    # 이전 릴리즈 디렉토리 확인
    local prev_release
    prev_release=$(remote "ls -dt $RELEASES_DIR/*/ 2>/dev/null | sed -n '2p'")

    if [ -z "$prev_release" ]; then
        error "롤백할 이전 버전이 없습니다."
        exit 1
    fi

    # 심볼릭 링크를 이전 버전으로 복구
    remote "ln -sfn $prev_release $CURRENT_LINK"
    remote "[ -f $DEPLOY_BASE/reload.sh ] && bash $DEPLOY_BASE/reload.sh || true"

    warn "롤백 완료: $prev_release"

    # 실패한 릴리즈 정리
    if [ -d "$RELEASE_DIR" ]; then
        remote "rm -rf $RELEASE_DIR"
    fi

    exit 1
}

# 배포 중 오류 발생 시 자동 롤백
trap 'rollback "예상치 못한 오류 발생"' ERR

# ─── 1단계: 사전 점검 ─────────────────────────────────────────────────────────
log "1단계: 사전 점검"

if [ -n "$DEPLOY_HOST" ]; then
    if ! ssh -o ConnectTimeout=10 "$DEPLOY_USER@$DEPLOY_HOST" "echo ok" > /dev/null 2>&1; then
        error "서버에 연결할 수 없습니다: $DEPLOY_HOST"
        exit 1
    fi
    success "서버 연결 확인"
fi

# 디렉토리 구조 초기화 (멱등성: 이미 있어도 괜찮음)
remote "mkdir -p $RELEASES_DIR $SHARED_DIR"
success "디렉토리 구조 확인"

# ─── 2단계: 파일 전송 ─────────────────────────────────────────────────────────
log "2단계: 파일 전송 ($TIMESTAMP)"

if [ -n "$DEPLOY_HOST" ]; then
    rsync -avz --delete \
        --exclude='.git' \
        --exclude='.env*' \
        --exclude='node_modules' \
        --exclude='__pycache__' \
        --exclude='*.pyc' \
        "$APP_DIR/" \
        "$DEPLOY_USER@$DEPLOY_HOST:$RELEASE_DIR/"
else
    # 로컬 모드: 현재 디렉토리를 릴리즈 디렉토리로 복사
    mkdir -p "$RELEASE_DIR"
    rsync -a --exclude='.git' --exclude='.env*' \
        "$APP_DIR/" "$RELEASE_DIR/"
fi

success "파일 전송 완료"

# ─── 3단계: 공유 파일 연결 ────────────────────────────────────────────────────
log "3단계: 공유 파일 연결"

# 공유 .env 파일 심볼릭 링크
remote "[ -f $SHARED_DIR/.env ] && ln -sf $SHARED_DIR/.env $RELEASE_DIR/.env || true"

# 공유 업로드 디렉토리 연결
remote "[ -d $SHARED_DIR/uploads ] && ln -sf $SHARED_DIR/uploads $RELEASE_DIR/uploads || true"

success "공유 파일 연결 완료"

# ─── 4단계: 앱 빌드 (선택) ────────────────────────────────────────────────────
log "4단계: 앱 빌드"

# 예시: Node.js 프로젝트
if remote "[ -f $RELEASE_DIR/package.json ]"; then
    remote "cd $RELEASE_DIR && npm install --production --silent 2>&1 | tail -3"
    success "npm install 완료"
fi

# 예시: Python 프로젝트
if remote "[ -f $RELEASE_DIR/requirements.txt ]"; then
    remote "cd $RELEASE_DIR && pip install -r requirements.txt -q"
    success "pip install 완료"
fi

# ─── 5단계: 심볼릭 링크 전환 (원자적 배포) ────────────────────────────────────
log "5단계: 심볼릭 링크 전환"
remote "ln -sfn $RELEASE_DIR $CURRENT_LINK"
success "current → $TIMESTAMP"

# ─── 6단계: 서비스 재시작 ─────────────────────────────────────────────────────
log "6단계: 서비스 재시작"
remote "systemctl restart myapp 2>/dev/null || true"
success "서비스 재시작 완료"

# ─── 7단계: 헬스 체크 ─────────────────────────────────────────────────────────
log "7단계: 헬스 체크"

APP_URL="${APP_URL:-http://localhost:8000}"
MAX_RETRIES=5
RETRY_INTERVAL=3

for i in $(seq 1 $MAX_RETRIES); do
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
        --connect-timeout 5 --max-time 10 "$APP_URL/health" 2>/dev/null || echo "000")

    if [ "$HTTP_STATUS" = "200" ]; then
        success "헬스 체크 통과 (HTTP $HTTP_STATUS)"
        break
    fi

    if [ "$i" -eq "$MAX_RETRIES" ]; then
        rollback "헬스 체크 실패 (HTTP $HTTP_STATUS) — $MAX_RETRIES회 시도"
    fi

    warn "헬스 체크 대기 중... ($i/$MAX_RETRIES, HTTP: $HTTP_STATUS)"
    sleep $RETRY_INTERVAL
done

# ─── 8단계: 오래된 릴리즈 정리 ───────────────────────────────────────────────
log "8단계: 오래된 릴리즈 정리"

remote "ls -dt $RELEASES_DIR/*/ | tail -n +$((KEEP_RELEASES + 1)) | xargs rm -rf --"
success "최근 $KEEP_RELEASES개 릴리즈만 유지"

# ─── 완료 ─────────────────────────────────────────────────────────────────────
trap - ERR   # 정상 완료 시 trap 해제

echo ""
success "배포 완료."
echo "  버전: $TIMESTAMP"
echo "  경로: $RELEASE_DIR"
echo ""