#!/usr/bin/env bash
set -euo pipefail

# 위험한 패턴: 입력값을 검증 없이 사용
dangerous_list() {
    local user_input="$1"
    ls "$user_input"   # user_input이 "-la /etc"이면?
}

# 안전한 패턴: 입력값 검증 후 사용
safe_list() {
    local user_input="$1"

    # 1. 절대 경로인지 확인
    if [[ "$user_input" != /* ]]; then
        echo "오류: 절대 경로만 허용합니다." >&2
        return 1
    fi

    # 2. 허용 문자만 포함하는지 확인 (알파벳, 숫자, /,  -, _,  . 만 허용)
    if [[ ! "$user_input" =~ ^[a-zA-Z0-9/_.-]+$ ]]; then
        echo "오류: 허용되지 않은 문자가 포함되어 있습니다." >&2
        return 1
    fi

    # 3. 디렉토리 탈출 시도 방지
    if [[ "$user_input" == *".."* ]]; then
        echo "오류: 상위 디렉토리 참조는 허용되지 않습니다." >&2
        return 1
    fi

    ls -- "$user_input"
}

echo "파일을 나열할 디렉토리를 입력하세요."
read -r user_dir
safe_list "$user_dir"