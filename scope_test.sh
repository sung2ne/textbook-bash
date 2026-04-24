#!/bin/bash

# 전역 변수
username="admin"
counter=0

# local 없이 — 전역 오염
bad_func() {
    username="hacker"     # 전역 변수 덮어씀
    counter=100           # 전역 변수 덮어씀
    echo "[bad_func] username=$username, counter=$counter"
}

# local 사용 — 안전
good_func() {
    local username="guest"   # 지역 변수
    local counter=1          # 지역 변수
    echo "[good_func] username=$username, counter=$counter"
}

echo "=== 초기 상태 ==="
echo "username=$username, counter=$counter"

echo ""
echo "=== bad_func 호출 ==="
bad_func
echo "호출 후: username=$username, counter=$counter"

echo ""
echo "=== 변수 복원 ==="
username="admin"
counter=0
echo "username=$username, counter=$counter"

echo ""
echo "=== good_func 호출 ==="
good_func
echo "호출 후: username=$username, counter=$counter"