# 로그 레벨 정의
declare -A LOG_LEVELS=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3 [FATAL]=4)
LOG_LEVEL="${LOG_LEVEL:-INFO}"
LOG_FILE="${LOG_FILE:-}"

_log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # 현재 설정 레벨보다 낮은 메시지는 출력하지 않음
    local level_num="${LOG_LEVELS[$level]:-1}"
    local threshold="${LOG_LEVELS[$LOG_LEVEL]:-1}"
    if [[ $level_num -lt $threshold ]]; then
        return 0
    fi

    local formatted="[${timestamp}] [${level}] ${message}"

    # 파일 출력 (LOG_FILE이 설정된 경우)
    if [[ -n "$LOG_FILE" ]]; then
        echo "$formatted" >> "$LOG_FILE"
    fi

    # 화면 출력 (ERROR/FATAL은 stderr)
    if [[ "$level" == "ERROR" || "$level" == "FATAL" ]]; then
        echo "$formatted" >&2
    else
        echo "$formatted"
    fi
}

log_debug() { _log "DEBUG" "$@"; }
log_info()  { _log "INFO"  "$@"; }
log_warn()  { _log "WARN"  "$@"; }
log_error() { _log "ERROR" "$@"; }
log_fatal() { _log "FATAL" "$@"; exit 1; }