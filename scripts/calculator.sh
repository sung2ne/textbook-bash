#!/bin/bash

# 입력 받기
read -p "첫 번째 숫자: " num1
read -p "연산자 (+, -, *, /): " operator
read -p "두 번째 숫자: " num2

# 계산
case "${operator}" in
  "+")
    result=$(( num1 + num2 ))
    ;;
  "-")
    result=$(( num1 - num2 ))
    ;;
  "*")
    result=$(( num1 * num2 ))
    ;;
  "/")
    if [[ "${num2}" -eq 0 ]]; then
      echo "오류: 0으로 나눌 수 없습니다."
      exit 1
    fi
    result=$(echo "scale=2; ${num1} / ${num2}" | bc)
    ;;
  *)
    echo "오류: 지원하지 않는 연산자입니다."
    exit 1
    ;;
esac

# 결과 출력
echo ""
echo "${num1} ${operator} ${num2} = ${result}"

exit 0