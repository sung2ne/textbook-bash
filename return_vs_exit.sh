#!/usr/bin/env bash

check_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "파일 없음: $file" >&2
        return 1   # 함수만 종료, 스크립트 계속 실행
    fi

    echo "파일 확인: $file"
    return 0
}

# 함수 호출 후 결과 확인
if check_file "/etc/passwd"; then
    echo "passwd 파일 존재"
fi

if check_file "/없는파일"; then
    echo "이 줄은 출력되지 않음"
else
    echo "파일 없음 처리됨"
fi

echo "스크립트는 계속 실행됩니다."