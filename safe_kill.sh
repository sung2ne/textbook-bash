#!/usr/bin/env bash

set -euo pipefail

# 사용법 출력
usage() {
    echo "사용법: $0 <프로세스이름> [SIGTERM_대기시간(초)]"
    echo "예시: $0 myapp 10"
    exit 1
}

# 안전한 프로세스 종료 함수
safe_kill() {
    local process_name="$1"
    local wait_seconds="${2:-10}"

    # 프로세스 존재 확인
    if ! pgrep -f "$process_name" > /dev/null 2>&1; then
        echo "'$process_name' 프로세스가 실행 중이지 않습니다."
        return 0
    fi

    # 실행 중인 PID 목록
    local pids
    pids=$(pgrep -f "$process_name" | tr '\n' ' ')
    echo "종료 대상 PID: $pids"

    # SIGTERM으로 정상 종료 시도
    echo "SIGTERM 전송..."
    pkill -TERM -f "$process_name" || true

    # 대기
    local elapsed=0
    while pgrep -f "$process_name" > /dev/null 2>&1; do
        if (( elapsed >= wait_seconds )); then
            echo "${wait_seconds}초 경과. SIGKILL로 강제 종료..."
            pkill -KILL -f "$process_name" || true
            sleep 1
            break
        fi
        echo -n "."
        sleep 1
        elapsed=$((elapsed + 1))
    done
    echo ""

    # 최종 확인
    if pgrep -f "$process_name" > /dev/null 2>&1; then
        echo "경고: 프로세스가 여전히 실행 중입니다."
        return 1
    else
        echo "'$process_name' 종료 완료."
        return 0
    fi
}

# 인수 확인
[[ $# -lt 1 ]] && usage

safe_kill "$1" "${2:-10}"