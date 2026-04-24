#!/bin/bash

file="$1"

if [[ -z "$file" ]]; then
    echo "사용법: $0 <파일경로>"
    exit 1
fi

if [[ ! -f "$file" ]]; then
    echo "오류: 파일이 없습니다 - $file"
    exit 1
fi

ext="${file##*.}"

case $ext in
    txt|md)
        echo "텍스트 파일입니다."
        echo "줄 수: $(wc -l < "$file")"
        echo "--- 내용 미리보기 ---"
        head -5 "$file"
        ;;
    sh)
        echo "쉘 스크립트입니다."
        echo "실행 권한 확인 중..."
        if [[ -x "$file" ]]; then
            echo "실행 권한이 있습니다."
        else
            echo "실행 권한이 없습니다. chmod +x $file 을 실행하세요."
        fi
        ;;
    py)
        echo "파이썬 스크립트입니다."
        python3 --version 2>/dev/null || echo "python3가 설치되지 않았습니다."
        echo "실행: python3 $file"
        ;;
    gz|tar|zip)
        echo "압축 파일입니다."
        echo "크기: $(du -sh "$file" | cut -f1)"
        ;;
    *)
        echo "알 수 없는 확장자입니다: .$ext"
        echo "파일 타입 확인: $(file "$file")"
        ;;
esac