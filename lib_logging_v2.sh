# ANSI 색상 코드
COLOR_RESET='\033[0m'
COLOR_GRAY='\033[0;90m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_RED='\033[0;31m'
COLOR_RED_BOLD='\033[1;31m'

declare -A LOG_LEVELS=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3 [FATAL]=4)
declare -A LOG_COLORS=(
    [DEBUG]="$COLOR_GRAY"
    [INFO]="$COLOR_GREEN"
    [WARN]="$COLOR_YELLOW"
    [ERROR]="$COLOR_RED"
    [FATAL]="$COLOR_RED_BOLD"
)

LOG_LEVEL="${LOG_LEVEL:-INFO}"
LOG_FILE="${LOG_FILE:-}"

# 터미널 여부 확인 (파일 리다이렉션 시 색상 코드 제거)
_is_terminal() {
    [[ -t 1 ]]
}

_log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    local level_num="${LOG_LEVELS[$level]:-1}"
    local threshold="${LOG_LEVELS[$LOG_LEVEL]:-1}"
    [[ $level_num -lt $threshold ]] && return 0

    local plain_msg="[${timestamp}] [${level}] ${message}"

    # 파일에는 색상 없이 저장
    if [[ -n "$LOG_FILE" ]]; then
        echo "$plain_msg" >> "$LOG_FILE"
    fi

    # 화면에는 색상 포함
    if _is_terminal; then
        local color="${LOG_COLORS[$level]:-}"
        printf "${color}%s${COLOR_RESET}\n" "$plain_msg"
    else
        echo "$plain_msg"
    fi
}

log_debug() { _log "DEBUG" "$@"; }
log_info()  { _log "INFO"  "$@"; }
log_warn()  { _log "WARN"  "$@"; }
log_error() { _log "ERROR" "$@"; }
log_fatal() { _log "FATAL" "$@"; exit 1; }