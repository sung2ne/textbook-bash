#!/bin/bash

seconds="${1:-10}"

if [[ ! $seconds =~ ^[0-9]+$ || $seconds -eq 0 ]]; then
    echo "사용법: $0 <초>"
    exit 1
fi

echo "카운트다운 시작: ${seconds}초"
echo "-----------------------------"

while [[ $seconds -gt 0 ]]; do
    printf "\r남은 시간: %3d초 " $seconds
    sleep 1
    ((seconds--))
done

printf "\r                    \r"
echo "시간이 종료되었습니다!"
echo "-----------------------------"