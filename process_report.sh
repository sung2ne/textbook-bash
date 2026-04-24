#!/usr/bin/env bash

set -euo pipefail

echo "===== 프로세스 현황 리포트 ====="
echo "시각: $(date)"
echo ""

echo "--- CPU 사용량 상위 5개 ---"
ps aux --sort=-%cpu | head -6 | awk 'NR==1{print} NR>1{printf "%-10s %5s %5s  %s\n", $1, $3, $4, $11}'

echo ""
echo "--- 메모리 사용량 상위 5개 ---"
ps aux --sort=-%mem | head -6 | awk 'NR==1{print} NR>1{printf "%-10s %5s %5s  %s\n", $1, $3, $4, $11}'

echo ""
echo "--- 프로세스 상태 요약 ---"
ps aux | awk 'NR>1{print $8}' | sort | uniq -c | sort -rn | \
  awk '{printf "  %s: %d개\n", $2, $1}'

echo ""
echo "--- 시스템 부하 ---"
uptime