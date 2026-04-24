#!/bin/bash

# 구분선 출력 함수
print_separator() {
    echo "=================================================="
}

# 로그 출력 함수 (타임스탬프 포함)
log() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1"
}

# 섹션 제목 출력 함수
print_section() {
    print_separator
    echo "  $1"
    print_separator
}

# --- 실행 ---
print_section "시스템 정보 수집"
log "스크립트 시작"
log "현재 사용자: $(whoami)"
log "현재 디렉토리: $(pwd)"
log "스크립트 완료"
print_separator