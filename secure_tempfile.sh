#!/usr/bin/env bash
set -euo pipefail

# 파일 생성 시 다른 사용자가 읽지 못하도록 설정
umask 077   # 생성 파일: 600 (rw-------), 디렉토리: 700

TEMP_FILE=$(mktemp)
TEMP_DIR=$(mktemp -d)

cleanup() {
    rm -f "$TEMP_FILE"
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# 이제 임시 파일은 소유자만 읽고 쓸 수 있음
echo "민감한 데이터" > "$TEMP_FILE"
ls -la "$TEMP_FILE"
# -rw------- 1 user user 15 Apr 24 09:30 /tmp/tmp.AbCdEf