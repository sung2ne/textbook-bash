#!/usr/bin/env bash
# lib_logging.sh — Bash 로깅 라이브러리
# 사용법: source lib_logging.sh
# 환경변수:
#   LOG_LEVEL — 출력 레벨 (DEBUG/INFO/WARN/ERROR/FATAL, 기본: INFO)
#   LOG_FILE  — 로그 파일 경로 (기본: 없음, 화면만 출력)

# ---- 색상 코드 ----
_LOG_COLOR_RESET='\033[0m'
_LOG_COLORS=([DEBUG]='\033[0;90m' [INFO]='\033[0;32m' [WARN]='\033[0;33m' [ERROR]='\033[0;31m' [FATAL]='\033[1;31m')

# ---- 로그 레벨 ----
declare -A _LOG_LEVELS=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3 [FATAL]=4)

LOG_LEVEL="${LOG_LEVEL:-INFO}"
LOG_FILE="${LOG_FILE:-}"

# ---- 내부 로그 함수 ----
_log_write() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # 레벨 필터
    local level_num="${_LOG_LEVELS[$level]:-1}"
    local threshold="${_LOG_LEVELS[$LOG_LEVEL]:-1}"
    [[ $level_num -lt $threshold ]] && return 0

    local plain_msg="[${timestamp}] [${level}] ${message}"

    # 파일에 저장 (색상 없이)
    if [[ -n "$LOG_FILE" ]]; then
        echo "$plain_msg" >> "$LOG_FILE"
    fi

    # 화면 출력 (터미널이면 색상, 아니면 plain)
    if [[ -t 1 || -t 2 ]]; then
        local color="${_LOG_COLORS[$level]:-}"
        if [[ "$level" == "ERROR" || "$level" == "FATAL" ]]; then
            printf "${color}%s${_LOG_COLOR_RESET}\n" "$plain_msg" >&2
        else
            printf "${color}%s${_LOG_COLOR_RESET}\n" "$plain_msg"
        fi
    else
        if [[ "$level" == "ERROR" || "$level" == "FATAL" ]]; then
            echo "$plain_msg" >&2
        else
            echo "$plain_msg"
        fi
    fi
}

# ---- 공개 함수 ----
log_debug() { _log_write "DEBUG" "$*"; }
log_info()  { _log_write "INFO"  "$*"; }
log_warn()  { _log_write "WARN"  "$*"; }
log_error() { _log_write "ERROR" "$*"; }
log_fatal() { _log_write "FATAL" "$*"; exit 1; }