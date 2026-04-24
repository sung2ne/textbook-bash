#!/usr/bin/env bash

# 테스트 데이터 생성
generate_test_log() {
    local lines="${1:-10000}"
    local file="/tmp/test.log"
    for i in $(seq 1 "$lines"); do
        local level
        if (( i % 10 == 0 )); then
            level="ERROR"
        else
            level="INFO"
        fi
        echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] 192.168.1.$((RANDOM % 254 + 1)) request processed"
    done > "$file"
    echo "$file"
}

LOG_FILE=$(generate_test_log 10000)
echo "테스트 파일: $LOG_FILE ($(wc -l < "$LOG_FILE")줄)"
echo ""

# 느린 방법: 루프에서 grep + cut
echo "=== 느린 방법 ==="
time (
    error_ips=()
    while IFS= read -r line; do
        if echo "$line" | grep -q "ERROR"; then
            ip=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
            error_ips+=("$ip")
        fi
    done < "$LOG_FILE"
    echo "에러 IP 개수: ${#error_ips[@]}"
)

echo ""

# 빠른 방법: grep + awk 한 번에
echo "=== 빠른 방법 ==="
time (
    count=$(grep "ERROR" "$LOG_FILE" | \
            grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | \
            wc -l)
    echo "에러 IP 개수: $count"
)

rm -f "$LOG_FILE"