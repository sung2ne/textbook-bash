#!/usr/bin/env bash

set -euo pipefail

TEMP_FILE=$(mktemp)

cleanup() {
    local exit_code=$?
    echo ""
    echo "정리 시작..."
    rm -f "$TEMP_FILE"
    echo "임시 파일 삭제 완료"
    exit "$exit_code"
}

# 어떤 방식으로 종료되든 cleanup 실행
trap cleanup EXIT ERR INT TERM

echo "작업 시작. 임시 파일: $TEMP_FILE"

# 작업 수행
for i in {1..5}; do
    echo "처리 중: $i/5"
    echo "데이터 $i" >> "$TEMP_FILE"
    sleep 1
done

echo "작업 완료"