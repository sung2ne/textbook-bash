#!/usr/bin/env bash

echo "일반 구간 - 추적 없음"

# 디버그 구간 시작
set -x
RESULT=$(ls /tmp | wc -l)
echo "파일 수: $RESULT"
set +x
# 디버그 구간 끝

echo "다시 일반 구간 - 추적 없음"