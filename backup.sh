#!/usr/bin/env bash

set -uo pipefail

readonly EXIT_OK=0
readonly EXIT_USAGE=2
readonly EXIT_SRC_NOT_FOUND=3
readonly EXIT_DST_NOT_FOUND=4
readonly EXIT_COPY_FAILED=5

usage() {
    echo "사용법: $0 <원본파일> <백업디렉토리>"
    echo ""
    echo "종료 코드:"
    echo "  0  성공"
    echo "  2  잘못된 사용법"
    echo "  3  원본 파일 없음"
    echo "  4  백업 디렉토리 없음"
    echo "  5  복사 실패"
    exit "$EXIT_USAGE"
}

[[ $# -ne 2 ]] && usage

SRC_FILE="$1"
BACKUP_DIR="$2"

if [[ ! -f "$SRC_FILE" ]]; then
    echo "오류: 원본 파일을 찾을 수 없습니다: $SRC_FILE" >&2
    exit "$EXIT_SRC_NOT_FOUND"
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "오류: 백업 디렉토리가 없습니다: $BACKUP_DIR" >&2
    exit "$EXIT_DST_NOT_FOUND"
fi

TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_NAME="$(basename "$SRC_FILE").${TIMESTAMP}.bak"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

if cp "$SRC_FILE" "$BACKUP_PATH"; then
    echo "백업 완료: $BACKUP_PATH"
    exit "$EXIT_OK"
else
    echo "오류: 복사에 실패했습니다." >&2
    exit "$EXIT_COPY_FAILED"
fi