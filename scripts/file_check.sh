#!/bin/bash

target="$1"

if [[ -z "$target" ]]; then
    echo "사용법: $0 <파일경로>"
    exit 1
fi

if [[ -f "$target" ]]; then
    size=$(wc -c < "$target")
    echo "파일 발견: $target (${size} bytes)"
    echo "내용 미리보기:"
    head -3 "$target"
elif [[ -d "$target" ]]; then
    count=$(ls "$target" | wc -l)
    echo "디렉토리 발견: $target (항목 ${count}개)"
    ls "$target"
else
    echo "$target 가 존재하지 않습니다."
    echo -n "새로 생성하시겠습니까? [y/N] "
    read answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        touch "$target"
        echo "파일을 생성했습니다: $target"
    else
        echo "취소했습니다."
    fi
fi