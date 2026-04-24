#!/bin/bash

# 요일 배열 (0 = 일요일)
days=("일요일" "월요일" "화요일" "수요일" "목요일" "금요일" "토요일")

# date +%w : 요일 번호 (0=일, 6=토)
today_num=$(date +%w)
today_name="${days[$today_num]}"

echo "오늘은 $today_name 입니다."

# 이번 주 전체 출력
echo ""
echo "=== 이번 주 요일 ==="
for (( i = 0; i < ${#days[@]}; i++ )); do
    if (( i == today_num )); then
        echo "  [$i] ${days[$i]} ← 오늘"
    else
        echo "  [$i] ${days[$i]}"
    fi
done

# 슬라이싱: 평일만
echo ""
echo "=== 평일 (월~금) ==="
weekdays=("${days[@]:1:5}")
for day in "${weekdays[@]}"; do
    echo "  $day"
done

exit 0