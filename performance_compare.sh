#!/usr/bin/env bash

TESTFILE="/etc/passwd"

echo "=== 테스트 1: cat + grep vs grep ==="
time (for i in {1..100}; do cat "$TESTFILE" | grep "root" > /dev/null; done)
echo "---"
time (for i in {1..100}; do grep "root" "$TESTFILE" > /dev/null; done)

echo ""
echo "=== 테스트 2: 외부 명령어 vs 매개변수 확장 ==="

# 느린 방법: cut으로 첫 번째 필드 추출
time (
    while IFS= read -r line; do
        echo "$line" | cut -d: -f1
    done < "$TESTFILE"
) > /dev/null

echo "---"

# 빠른 방법: 매개변수 확장
time (
    while IFS=: read -r username _rest; do
        echo "$username"
    done < "$TESTFILE"
) > /dev/null