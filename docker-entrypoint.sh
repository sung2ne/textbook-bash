#!/bin/bash
# docker-entrypoint.sh: Docker 컨테이너 시작 스크립트

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[entrypoint]${NC} $*"; }
warn() { echo -e "${YELLOW}[entrypoint]${NC} $*"; }
err()  { echo -e "${RED}[entrypoint]${NC} $*" >&2; }

# ─── 1. 환경 변수 기본값 설정 ─────────────────────────────────────────────────
log "환경 변수 기본값 설정 중..."

export APP_ENV="${APP_ENV:-production}"
export APP_PORT="${APP_PORT:-3000}"
export DB_PORT="${DB_PORT:-5432}"
export REDIS_PORT="${REDIS_PORT:-6379}"
export LOG_LEVEL="${LOG_LEVEL:-info}"

log "  환경: $APP_ENV"
log "  포트: $APP_PORT"

# ─── 2. 필수 환경 변수 검증 ───────────────────────────────────────────────────
log "필수 환경 변수 검증 중..."

REQUIRED_VARS=(
    "DB_HOST"
    "DB_NAME"
    "DB_USER"
    "DB_PASSWORD"
)

MISSING=0
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var:-}" ]; then
        err "  누락된 환경 변수: $var"
        MISSING=$((MISSING + 1))
    fi
done

if [ $MISSING -gt 0 ]; then
    err "$MISSING개 필수 환경 변수가 없습니다. 컨테이너를 종료합니다."
    exit 1
fi

log "  환경 변수 검증 완료"

# ─── 3. 설정 파일 생성 ────────────────────────────────────────────────────────
log "설정 파일 생성 중..."

# nginx 설정 생성 (템플릿이 있을 때)
if [ -f "/etc/nginx/nginx.conf.template" ]; then
    envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
    log "  nginx 설정 생성 완료"
fi

# 앱 설정 파일 생성
if [ -f "/app/config.template.json" ]; then
    envsubst < /app/config.template.json > /app/config.json
    log "  앱 설정 생성 완료"
fi

# ─── 4. 데이터베이스 연결 대기 ────────────────────────────────────────────────
wait_for_db() {
    local host=$1
    local port=$2
    local max_wait=${3:-60}   # 최대 대기 시간(초)
    local elapsed=0

    log "데이터베이스 연결 대기 중 ($host:$port)..."

    while ! nc -z "$host" "$port" > /dev/null 2>&1; do
        if [ $elapsed -ge $max_wait ]; then
            err "데이터베이스에 ${max_wait}초 내에 연결할 수 없습니다."
            exit 1
        fi
        warn "  DB 응답 없음, 재시도 중... (${elapsed}s / ${max_wait}s)"
        sleep 2
        elapsed=$((elapsed + 2))
    done

    log "  데이터베이스 연결 성공 (${elapsed}s 소요)"
}

if [ -n "${DB_HOST:-}" ]; then
    wait_for_db "$DB_HOST" "${DB_PORT:-5432}" 60
fi

if [ -n "${REDIS_HOST:-}" ]; then
    wait_for_db "$REDIS_HOST" "${REDIS_PORT:-6379}" 30
fi

# ─── 5. 데이터베이스 마이그레이션 (선택) ──────────────────────────────────────
if [ "${RUN_MIGRATIONS:-false}" = "true" ]; then
    log "데이터베이스 마이그레이션 실행 중..."

    # 프레임워크에 맞게 수정
    # Node.js: npx prisma migrate deploy
    # Python:  alembic upgrade head
    # Rails:   rails db:migrate

    log "  마이그레이션 완료"
fi

# ─── 6. CMD 실행 ──────────────────────────────────────────────────────────────
log "애플리케이션 시작: $*"
echo ""

# exec로 교체 — 이후 쉘 스크립트 프로세스가 앱 프로세스로 대체됨
# SIGTERM, SIGINT 등 시그널이 앱에 직접 전달됨
exec "$@"