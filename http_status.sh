#!/bin/bash

# HTTP 상태 코드 사전
declare -A http_status=(
    [200]="OK"
    [201]="Created"
    [204]="No Content"
    [301]="Moved Permanently"
    [302]="Found"
    [304]="Not Modified"
    [400]="Bad Request"
    [401]="Unauthorized"
    [403]="Forbidden"
    [404]="Not Found"
    [405]="Method Not Allowed"
    [409]="Conflict"
    [422]="Unprocessable Entity"
    [429]="Too Many Requests"
    [500]="Internal Server Error"
    [502]="Bad Gateway"
    [503]="Service Unavailable"
    [504]="Gateway Timeout"
)

# 상태 코드 조회 함수
lookup_status() {
    local code="$1"

    if [[ -v http_status[$code] ]]; then
        echo "${code} ${http_status[$code]}"
        return 0
    else
        echo "알 수 없는 상태 코드: ${code}"
        return 1
    fi
}

# 상태 코드 종류별 출력
print_by_range() {
    local label="$1"
    local start="$2"
    local end="$3"
    local code

    echo "--- ${label} ---"
    # 키를 정렬해서 출력
    for code in $(echo "${!http_status[@]}" | tr ' ' '\n' | sort -n); do
        if (( code >= start && code <= end )); then
            printf "  %-6s %s\n" "${code}" "${http_status[$code]}"
        fi
    done
}

# --- 실행 ---
echo "=== HTTP 상태 코드 조회 ==="
echo ""

# 개별 조회
lookup_status 200
lookup_status 404
lookup_status 500
lookup_status 999   # 없는 코드

echo ""

# 범위별 출력
print_by_range "2xx 성공" 200 299
echo ""
print_by_range "3xx 리다이렉션" 300 399
echo ""
print_by_range "4xx 클라이언트 오류" 400 499
echo ""
print_by_range "5xx 서버 오류" 500 599