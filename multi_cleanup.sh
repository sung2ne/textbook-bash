#!/usr/bin/env bash

set -euo pipefail

TEMP_DIR=""
PID_FILE="/tmp/myapp.pid"
DB_CONNECTED=false

cleanup() {
    local exit_code=$?

    # 1. 데이터베이스 연결 해제
    if $DB_CONNECTED; then
        echo "DB 연결 해제..."
        # db_disconnect 명령어 실행
        DB_CONNECTED=false
    fi

    # 2. 임시 파일 정리
    if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
        echo "임시 파일 정리..."
        rm -rf "$TEMP_DIR"
    fi

    # 3. PID 파일 삭제
    rm -f "$PID_FILE"

    # 4. 종료 로그
    if [[ $exit_code -ne 0 ]]; then
        echo "비정상 종료. 종료 코드: $exit_code" >&2
    fi

    exit "$exit_code"
}

trap cleanup EXIT

# PID 파일 생성
echo $$ > "$PID_FILE"

# 임시 디렉토리 생성
TEMP_DIR=$(mktemp -d)

# 작업 수행
echo "작업 시작..."
DB_CONNECTED=true

# ... 실제 작업 ...

echo "완료"