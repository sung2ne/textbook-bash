#!/bin/bash
# lib_utils.sh — 공통 유틸리티 함수 라이브러리

# 색상 코드 상수
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'   # No Color (초기화)

# 로그 함수들
log_info() {
    local message="$1"
    echo -e "${BLUE}[INFO]${NC}  $(date '+%H:%M:%S') $message"
}

log_warn() {
    local message="$1"
    echo -e "${YELLOW}[WARN]${NC}  $(date '+%H:%M:%S') $message" >&2
}

log_error() {
    local message="$1"
    echo -e "${RED}[ERROR]${NC} $(date '+%H:%M:%S') $message" >&2
}

# 색상 출력 함수들
print_green() {
    echo -e "${GREEN}$1${NC}"
}

print_red() {
    echo -e "${RED}$1${NC}"
}

print_yellow() {
    echo -e "${YELLOW}$1${NC}"
}

# 사용자 확인 프롬프트
# 사용법: confirm "계속하시겠습니까" && do_something
confirm() {
    local prompt="${1:-계속하시겠습니까?}"
    local answer

    read -rp "${prompt} [y/N] " answer
    case "$answer" in
        [yY] | [yY][eE][sS])
            return 0   # 승인
            ;;
        *)
            return 1   # 거부
            ;;
    esac
}

# 구분선 출력
print_separator() {
    echo "=================================================="
}

# 섹션 헤더 출력
print_header() {
    local title="$1"
    print_separator
    echo "  ${title}"
    print_separator
}