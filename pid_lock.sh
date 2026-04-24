#!/usr/bin/env bash

set -euo pipefail

PID_FILE="/var/run/myapp.pid"

cleanup() {
    rm -f "$PID_FILE"
}

# 이미 실행 중인지 확인
if [[ -f "$PID_FILE" ]]; then
    old_pid=$(cat "$PID_FILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        echo "오류: 이미 실행 중입니다. PID: $old_pid"
        exit 1
    else
        echo "경고: 이전 PID 파일이 남아있습니다. 제거 후 계속합니다."
        rm -f "$PID_FILE"
    fi
fi

# PID 파일 생성
echo $$ > "$PID_FILE"
trap cleanup EXIT

echo "작업 시작. PID: $$"
echo "PID 파일: $PID_FILE"

# ... 실제 작업 ...
sleep 10

echo "작업 완료"