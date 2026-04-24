_log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    local level_num="${LOG_LEVELS[$level]:-1}"
    local threshold="${LOG_LEVELS[$LOG_LEVEL]:-1}"
    [[ $level_num -lt $threshold ]] && return 0

    # 호출자 정보 (DEBUG 레벨에서만 포함)
    local caller_info=""
    if [[ "${LOG_LEVELS[$level]}" -eq 0 ]]; then
        local caller_file="${BASH_SOURCE[2]:-unknown}"
        local caller_line="${BASH_LINENO[1]:-0}"
        local caller_func="${FUNCNAME[2]:-main}"
        caller_info=" (${caller_file##*/}:${caller_line} ${caller_func})"
    fi

    local plain_msg="[${timestamp}] [${level}]${caller_info} ${message}"

    [[ -n "$LOG_FILE" ]] && echo "$plain_msg" >> "$LOG_FILE"
    echo "$plain_msg"
}