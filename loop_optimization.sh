#!/usr/bin/env bash

# 느린 방법: 루프마다 wc 실행
echo "=== 느린 방법 ==="
total_lines=0
for file in /etc/*.conf; do
    lines=$(wc -l < "$file")   # 파일마다 wc 프로세스 생성
    total_lines=$((total_lines + lines))
done
echo "총 줄 수: $total_lines"

# 빠른 방법: wc를 한 번만 실행
echo "=== 빠른 방법 ==="
total_lines=$(cat /etc/*.conf | wc -l)   # 한 번의 wc
echo "총 줄 수: $total_lines"

# 또는 xargs 활용
total_lines=$(wc -l /etc/*.conf | tail -1 | awk '{print $1}')
echo "총 줄 수: $total_lines"