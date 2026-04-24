#!/bin/bash

# 사용자 정보 입력
read -p "이름을 입력하세요: " user_name
read -p "나이를 입력하세요: " user_age

# 기본값 설정
user_name="${user_name:-익명}"
user_age="${user_age:-0}"

# 인사말 출력
echo ""
echo "==============================="
echo "  안녕하세요, ${user_name}님!"
echo "  나이: ${user_age}세"
echo "  접속 시각: $(date '+%Y-%m-%d %H:%M')"
echo "==============================="

exit 0