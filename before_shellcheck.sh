#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/tmp/backup"

backup_file() {
    local src="$1"
    local dst
    dst=$(mktemp "${BACKUP_DIR}/backup.XXXXXX")

    if cp "$src" "$dst"; then
        echo "백업 완료: $dst"
    else
        echo "백업 실패: $src" >&2
        return 1
    fi
}

mkdir -p "$BACKUP_DIR"

echo "백업할 파일을 입력하세요."
read -r file
backup_file "$file"