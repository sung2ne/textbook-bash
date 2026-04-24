#!/usr/bin/env bash

# PS4 설정: 파일명:줄번호:함수명: 형식
export PS4='+${BASH_SOURCE[0]##*/}:${LINENO}:${FUNCNAME[0]:-main}: '

set -x

greet() {
    local name="$1"
    echo "안녕하세요, ${name}님"
}

USER_NAME="홍길동"
greet "$USER_NAME"