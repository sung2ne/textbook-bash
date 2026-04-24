#!/usr/bin/env bash

# ==========================================
# 견고한 스크립트 템플릿
# 사용법: ./robust_template.sh [인수]
# ==========================================

set -euo pipefail

# ---- 상수 정의 ----
readonly SCRIPT_NAME=$(basename "$0" .sh)
readonly SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
readonly TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
readonly LOG_FILE="/tmp/${SCRIPT_NAME}_${TIMESTAMP}.log"

# ---- 로그 함수 ----
log() {
    local level="$1"
    shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] $*" | tee -a "$LOG_FILE"
}

# ---- 스택 트레이스 ----
print_stack_trace() {
    echo "" >&2
    echo "=== 스택 트레이스 ===" >&2
    local i
    for (( i=1; i<${#FUNCNAME[@]}; i++ )); do
        echo "  #$((i-1)) ${BASH_SOURCE[$i]:-main}:${BASH_LINENO[$((i-1))]} in ${FUNCNAME[$i]:-main}()" >&2
    done
    echo "===================" >&2
}

# ---- 롤백 스택 ----
ROLLBACK_STACK=()

push_rollback() {
    ROLLBACK_STACK+=("$1")
}

do_rollback() {
    if [[ ${#ROLLBACK_STACK[@]} -eq 0 ]]; then
        return
    fi
    log "WARN" "롤백 시작 (${#ROLLBACK_STACK[@]}개 작업)"
    local i
    for (( i=${#ROLLBACK_STACK[@]}-1; i>=0; i-- )); do
        log "WARN" "롤백: ${ROLLBACK_STACK[$i]}"
        eval "${ROLLBACK_STACK[$i]}" || true
    done
    log "WARN" "롤백 완료"
}

# ---- 에러 핸들러 ----
error_handler() {
    local exit_code=$?
    local line_number=$1
    log "ERROR" "오류 발생: 줄 ${line_number}, 종료 코드: ${exit_code}"
    print_stack_trace
    do_rollback
    log "ERROR" "로그 파일: ${LOG_FILE}"
    exit "${exit_code}"
}

# ---- EXIT 핸들러 ----
on_exit() {
    local exit_code=$?
    if [[ $exit_code -eq 0 ]]; then
        log "INFO" "스크립트 정상 완료"
    fi
}

trap 'error_handler ${LINENO}' ERR
trap on_exit EXIT

# ==========================================
# 메인 로직
# ==========================================
log "INFO" "스크립트 시작: ${SCRIPT_NAME}"

# 여기에 실제 작업 코드를 작성
TEMP_DIR=$(mktemp -d)
push_rollback "rm -rf ${TEMP_DIR}"

log "INFO" "임시 디렉토리 생성: ${TEMP_DIR}"

# 작업 예시
echo "처리할 데이터" > "${TEMP_DIR}/input.txt"
sort "${TEMP_DIR}/input.txt" > "${TEMP_DIR}/output.txt"

log "INFO" "처리 완료"
cat "${TEMP_DIR}/output.txt"