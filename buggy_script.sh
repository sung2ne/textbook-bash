#!/usr/bin/env bash
set -euo pipefail

count_files() {
    local dir="$1"
    local ext="$2"
    local count
    count=$(find "$dir" -name "*.${ext}" | wc -l)
    echo "$count"
}

if [[ $# -ne 2 ]]; then
    echo "사용법: $0 <디렉토리> <확장자>" >&2
    exit 2
fi

TARGET_DIR="$1"
EXTENSION="$2"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "오류: 디렉토리를 찾을 수 없습니다: $TARGET_DIR" >&2
    exit 3
fi

TOTAL=$(count_files "$TARGET_DIR" "$EXTENSION")
echo "${EXTENSION} 파일 개수: $TOTAL"