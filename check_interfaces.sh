#!/bin/bash

echo "=== 네트워크 인터페이스 상태 ==="
echo ""

# ip 명령어로 인터페이스 목록 조회
ip -brief addr show | while read -r iface state ip_info; do
    printf "%-15s %-10s %s\n" "$iface" "$state" "$ip_info"
done

echo ""
echo "=== 라우팅 테이블 ==="
ip route show