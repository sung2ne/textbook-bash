#!/bin/bash

# 현재 디렉토리의 파일 목록을 배열로 읽기
readarray -t all_files < <(find . -maxdepth 1 -type f | sort)

echo "=== 전체 파일 목록 ==="
for (( i = 0; i < ${#all_files[@]}; i++ )); do
    printf "  [%2d] %s\n" "$i" "${all_files[$i]}"
done
echo "총 ${#all_files[@]}개"

# 확장자별 필터링 함수
filter_by_ext() {
    local -n result=$1    # 결과 배열 (nameref)
    local ext="$2"

    result=()
    for f in "${all_files[@]}"; do
        if [[ "$f" == *."$ext" ]]; then
            result+=("$f")
        fi
    done
}

echo ""
echo "=== 확장자별 분류 ==="

declare -a sh_files
declare -a md_files

filter_by_ext sh_files "sh"
filter_by_ext md_files "md"

echo ".sh 파일 (${#sh_files[@]}개):"
for f in "${sh_files[@]}"; do
    echo "  $f"
done

echo ".md 파일 (${#md_files[@]}개):"
for f in "${md_files[@]}"; do
    echo "  $f"
done

# 크기 기준 정렬 (가장 큰 파일 순)
echo ""
echo "=== 크기 기준 상위 5개 ==="
readarray -t large_files < <(find . -maxdepth 1 -type f -printf "%s\t%f\n" | sort -rn | head -5)
for entry in "${large_files[@]}"; do
    size=$(echo "$entry" | cut -f1)
    name=$(echo "$entry" | cut -f2)
    printf "  %8d bytes  %s\n" "$size" "$name"
done