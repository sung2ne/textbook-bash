#!/bin/bash
# system_info.sh — lib_utils.sh를 활용한 시스템 정보 출력

# 라이브러리 로드 (스크립트 위치 기준)
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "${SCRIPT_DIR}/lib_utils.sh"

# 시스템 정보 수집 함수
get_cpu_info() {
    local cpu
    cpu=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
    echo "$cpu"
}

get_memory_info() {
    local total used
    total=$(free -m | awk '/^Mem:/ {print $2}')
    used=$(free -m | awk '/^Mem:/ {print $3}')
    echo "사용 중: ${used}MB / 전체: ${total}MB"
}

get_disk_info() {
    df -h / | awk 'NR==2 {printf "사용 중: %s / 전체: %s (%s)", $3, $2, $5}'
}

# --- 메인 실행 ---
print_header "시스템 정보 보고서"
echo ""

log_info "정보 수집 시작..."

echo ""
print_green "호스트명:     $(hostname)"
print_green "사용자:       $(whoami)"
print_green "운영체제:     $(lsb_release -d 2>/dev/null | cut -f2 || uname -o)"
print_green "커널 버전:    $(uname -r)"
print_green "가동 시간:    $(uptime -p 2>/dev/null || uptime)"
echo ""
print_green "CPU:          $(get_cpu_info)"
print_green "메모리:       $(get_memory_info)"
print_green "디스크(/):    $(get_disk_info)"

echo ""
log_info "정보 수집 완료."
print_separator

# 계속할지 물어보기
echo ""
if confirm "시스템 점검을 계속하시겠습니까"; then
    log_info "점검을 계속합니다."
    # 추가 점검 작업 ...
else
    log_warn "점검을 중단합니다."
fi