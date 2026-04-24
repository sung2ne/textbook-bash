#!/bin/bash

# 두 수 중 최대값을 반환하는 함수
max_of() {
    if (( $1 >= $2 )); then
        echo "$1"
    else
        echo "$2"
    fi
}

# 문자열을 N번 반복하는 함수
repeat_str() {
    local str="$1"
    local count="$2"
    local result=""
    local i

    for (( i = 0; i < count; i++ )); do
        result="${result}${str}"
    done

    echo "$result"
}

# 파일이 읽기 가능한지 확인하는 함수 (return 방식)
is_readable() {
    if [[ -r "$1" ]]; then
        return 0
    else
        return 1
    fi
}

# --- 실행 ---
bigger=$(max_of 42 17)
echo "42와 17 중 큰 수: $bigger"

bigger=$(max_of 5 99)
echo "5와 99 중 큰 수: $bigger"

line=$(repeat_str "-" 30)
echo "$line"

star_line=$(repeat_str "* " 10)
echo "$star_line"

if is_readable "/etc/hostname"; then
    echo "/etc/hostname 읽기 가능"
else
    echo "/etc/hostname 읽기 불가"
fi