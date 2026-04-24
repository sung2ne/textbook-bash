#!/bin/bash
# CI 린트 검사 스크립트

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "ShellCheck 린트 검사를 시작합니다..."
echo ""

ERRORS=0

# 모든 쉘 스크립트 검사
while IFS= read -r -d '' script; do
    echo -n "검사 중: $script ... "
    if output=$(shellcheck "$script" 2>&1); then
        echo -e "${GREEN}통과${NC}"
    else
        echo -e "${RED}실패${NC}"
        echo "$output"
        ERRORS=$((ERRORS + 1))
    fi
done < <(find scripts/ -name "*.sh" -print0 2>/dev/null)

echo ""
if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}린트 실패: ${ERRORS}개 파일에서 오류 발견${NC}"
    exit 1
fi

echo -e "${GREEN}모든 린트 검사 통과${NC}"
exit 0