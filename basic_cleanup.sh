#!/usr/bin/env bash

set -euo pipefail

TEMP_FILE=""

cleanup() {
    echo "정리 중..."
    [[ -n "$TEMP_FILE" && -f "$TEMP_FILE" ]] && rm -f "$TEMP_FILE"
    echo "완료"
}

trap cleanup EXIT

# 이제부터 임시 파일 생성
TEMP_FILE=$(mktemp)
echo "임시 파일: $TEMP_FILE"

# 작업 수행
echo "데이터 처리 중..." > "$TEMP_FILE"
sleep 2
cat "$TEMP_FILE"

# 명시적 삭제 없이 종료해도 cleanup이 처리함