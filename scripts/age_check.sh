#!/bin/bash

echo -n "나이를 입력하세요: "
read age

if [[ ! $age =~ ^[0-9]+$ ]]; then
    echo "오류: 숫자만 입력하세요."
    exit 1
fi

if [[ $age -lt 0 || $age -gt 150 ]]; then
    echo "오류: 유효하지 않은 나이입니다."
    exit 1
fi

if [[ $age -lt 19 ]]; then
    echo "${age}세 → 미성년자입니다."
elif [[ $age -lt 65 ]]; then
    echo "${age}세 → 성인입니다."
else
    echo "${age}세 → 노인입니다."
fi