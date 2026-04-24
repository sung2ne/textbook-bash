#!/bin/bash

count=0

(( count++ ))    # count를 1 증가 (후위 증가)
echo "count: ${count}"    # 출력: 1

(( count += 5 ))    # count에 5 추가
echo "count: ${count}"    # 출력: 6

(( count-- ))    # count를 1 감소
echo "count: ${count}"    # 출력: 5

(( count *= 2 ))    # count에 2 곱하기
echo "count: ${count}"    # 출력: 10

exit 0