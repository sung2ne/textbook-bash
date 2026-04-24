#!/usr/bin/env bash

set -uo pipefail

# 종료 코드 상수 정의
readonly EXIT_OK=0
readonly EXIT_ERROR=1
readonly EXIT_USAGE=2
readonly EXIT_NOT_FOUND=3
readonly EXIT_PERMISSION=4
readonly EXIT_TIMEOUT=5

usage() {
    echo "사용법: $0 <파일경로>"
    exit "$EXIT_USAGE"
}

process_file() {
    local file="$1"

    if [[ ! -e "$file" ]]; then
        echo "오류: 파일을 찾을 수 없습니다: $file" >&2
        exit "$EXIT_NOT_FOUND"
    fi

    if [[ ! -r "$file" ]]; then
        echo "오류: 파일을 읽을 수 없습니다: $file" >&2
        exit "$EXIT_PERMISSION"
    fi

    echo "처리 중: $file"
    wc -l "$file"
    exit "$EXIT_OK"
}

# 인수 검사
if [[ $# -ne 1 ]]; then
    usage
fi

process_file "$1"