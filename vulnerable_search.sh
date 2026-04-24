#!/usr/bin/env bash
set -euo pipefail

readonly MAX_KEYWORD_LENGTH=100
readonly ALLOWED_SEARCH_DIRS=("/tmp" "/home" "/var/log")

validate_keyword() {
    local keyword="$1"

    if [[ ${#keyword} -gt $MAX_KEYWORD_LENGTH ]]; then
        echo "오류: 키워드가 너무 깁니다 (최대 ${MAX_KEYWORD_LENGTH}자)." >&2
        return 1
    fi

    # 특수 문자 허용 안 함 (영문, 숫자, 공백, 기본 기호만)
    if [[ ! "$keyword" =~ ^[a-zA-Z0-9가-힣\ ._-]+$ ]]; then
        echo "오류: 키워드에 허용되지 않은 문자가 포함되어 있습니다." >&2
        return 1
    fi
}

validate_directory() {
    local dir="$1"
    local allowed=false

    # 허용된 디렉토리 목록에 있는지 확인
    for allowed_dir in "${ALLOWED_SEARCH_DIRS[@]}"; do
        if [[ "$dir" == "$allowed_dir" || "$dir" == "$allowed_dir/"* ]]; then
            allowed=true
            break
        fi
    done

    if ! $allowed; then
        echo "오류: 허용되지 않은 디렉토리입니다: $dir" >&2
        echo "허용 디렉토리: ${ALLOWED_SEARCH_DIRS[*]}" >&2
        return 1
    fi

    if [[ ! -d "$dir" ]]; then
        echo "오류: 디렉토리가 존재하지 않습니다: $dir" >&2
        return 1
    fi
}

echo "검색할 키워드를 입력하세요."
read -r keyword

echo "검색할 디렉토리를 입력하세요 (허용: ${ALLOWED_SEARCH_DIRS[*]})."
read -r search_dir

validate_keyword "$keyword" || exit 1
validate_directory "$search_dir" || exit 1

echo "검색 중: '$keyword' in '$search_dir'"

# eval 없이 안전하게 실행
grep -r -- "$keyword" "$search_dir" 2>/dev/null || echo "검색 결과가 없습니다."