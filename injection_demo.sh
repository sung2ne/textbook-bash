#!/usr/bin/env bash

# 위험: eval을 사용하거나 변수를 따옴표 없이 사용
# 입력값: "hello; rm -rf /tmp/important"
dangerous_echo() {
    local input="$1"
    eval "echo $input"   # 세미콜론 뒤의 rm이 실행됨
}

# 안전: 변수를 항상 따옴표로 감싸기
safe_echo() {
    local input="$1"
    echo "$input"        # 그냥 문자열로 전달
}

# 위험: 명령어 구성에 변수를 직접 사용
# 입력값: "file.txt; cat /etc/passwd"
dangerous_view() {
    local filename="$1"
    cat /logs/$filename   # 경로 조작 가능
}

# 안전: 파일명만 추출해서 사용
safe_view() {
    local filename="$1"
    # basename으로 경로 조작 방지
    local safe_name
    safe_name=$(basename "$filename")
    cat "/logs/${safe_name}"
}