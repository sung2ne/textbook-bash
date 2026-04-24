#!/bin/bash
# env_setup.sh: 환경 감지 → 설정 로드 → 검증

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ─── 환경 감지 ────────────────────────────────────────────────────────────────
detect_environment() {
    # 1. 명시적으로 지정된 경우
    if [ -n "${APP_ENV:-}" ]; then
        echo "$APP_ENV"
        return
    fi

    # 2. CI 환경 감지 (GitHub Actions, GitLab CI 등)
    if [ -n "${CI:-}" ]; then
        echo "staging"
        return
    fi

    # 3. Git 브랜치로 감지
    local branch
    branch=$(git -C "$PROJECT_ROOT" symbolic-ref --short HEAD 2>/dev/null || echo "unknown")

    case "$branch" in
        main|master)   echo "prod" ;;
        develop)       echo "dev" ;;
        staging)       echo "staging" ;;
        *)             echo "dev" ;;
    esac
}

ENV=$(detect_environment)
ENV_FILE="$PROJECT_ROOT/.env.$ENV"

echo -e "${CYAN}환경 설정을 시작합니다...${NC}"
echo "  감지된 환경: $ENV"

# ─── .env 파일 로드 ───────────────────────────────────────────────────────────
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${YELLOW}  경고: $ENV_FILE 파일이 없습니다. .env 파일을 사용합니다.${NC}"
    ENV_FILE="$PROJECT_ROOT/.env"
fi

if [ -f "$ENV_FILE" ]; then
    # shellcheck disable=SC1090
    set -a
    source "$ENV_FILE"
    set +a
    echo -e "${GREEN}  설정 로드 완료: $ENV_FILE${NC}"
else
    echo -e "${RED}  오류: 설정 파일을 찾을 수 없습니다.${NC}"
    exit 1
fi

# ─── 환경 변수 검증 ───────────────────────────────────────────────────────────
bash "$PROJECT_ROOT/scripts/validate_env.sh"

# ─── 설정 파일 생성 (템플릿 있을 때) ──────────────────────────────────────────
if [ -f "$PROJECT_ROOT/config/nginx.conf.template" ]; then
    envsubst < "$PROJECT_ROOT/config/nginx.conf.template" \
        > "$PROJECT_ROOT/config/nginx.conf"
    echo -e "${GREEN}  nginx 설정 파일 생성 완료${NC}"
fi

echo ""
echo -e "${GREEN}환경 설정 완료 (환경: $ENV)${NC}"