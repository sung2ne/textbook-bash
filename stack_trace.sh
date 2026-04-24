#!/usr/bin/env bash
set -euo pipefail

print_stack_trace() {
    echo "" >&2
    echo "=== 스택 트레이스 ===" >&2
    local i
    for (( i=1; i<${#FUNCNAME[@]}; i++ )); do
        echo "  #$((i-1)) ${BASH_SOURCE[$i]:-main}:${BASH_LINENO[$((i-1))]} in ${FUNCNAME[$i]:-main}()" >&2
    done
    echo "===================" >&2
}

error_handler() {
    local exit_code=$?
    local line_number=$1
    echo "" >&2
    echo "[ERROR] 줄 ${line_number}에서 오류 발생 (종료 코드: ${exit_code})" >&2
    print_stack_trace
}

trap 'error_handler ${LINENO}' ERR

# 중첩 함수 호출로 스택 트레이스 테스트
level3() {
    ls /없는경로   # 오류 발생 위치
}

level2() {
    level3
}

level1() {
    level2
}

echo "함수 호출 체인 시작"
level1