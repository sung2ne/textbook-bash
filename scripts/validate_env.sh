#!/bin/bash
# validate_env.sh: 필수 환경 변수 존재 확인

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# 필수 변수 목록
REQUIRED_VARS=(
    "APP_ENV"
    "APP_PORT"
    "DB_HOST"
    "DB_PORT"
    "DB_NAME"
    "DB_USER"
    "DB_PASSWORD"
    "API_KEY"
)

MISSING=0

echo "환경 변수 검증 중..."
echo ""

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var:-}" ]; then
        echo -e "${RED}  누락: $var${NC}"
        MISSING=$((MISSING + 1))
    else
        # 값을 보여주되 민감한 변수는 마스킹
        if [[ "$var" == *"PASSWORD"* ]] || [[ "$var" == *"KEY"* ]] || [[ "$var" == *"SECRET"* ]]; then
            echo -e "${GREEN}  설정됨: $var = ****${NC}"
        else
            echo -e "${GREEN}  설정됨: $var = ${!var}${NC}"
        fi
    fi
done

echo ""

if [ $MISSING -gt 0 ]; then
    echo -e "${RED}${MISSING}개 필수 환경 변수가 없습니다.${NC}"
    exit 1
fi

echo -e "${GREEN}모든 필수 환경 변수가 설정되어 있습니다.${NC}"
exit 0