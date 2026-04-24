#!/usr/bin/env bash

set -euo pipefail

TEMP_DIR=""

cleanup() {
    if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
        echo "임시 디렉토리 삭제: $TEMP_DIR"
    fi
}

trap cleanup EXIT

TEMP_DIR=$(mktemp -d)
echo "작업 디렉토리: $TEMP_DIR"

# 임시 디렉토리 안에서 모든 중간 파일 생성
echo "원본 데이터" > "${TEMP_DIR}/input.txt"
sort "${TEMP_DIR}/input.txt" > "${TEMP_DIR}/sorted.txt"
uniq "${TEMP_DIR}/sorted.txt" > "${TEMP_DIR}/unique.txt"

echo "처리 결과:"
cat "${TEMP_DIR}/unique.txt"

# cleanup이 디렉토리 전체를 한 번에 삭제