#!/bin/bash

source_ext="${1:-txt}"
target_ext="${2:-bak}"

count=0
skipped=0

echo "변환: .$source_ext → .$target_ext"
echo "-----------------------------"

for file in *."$source_ext"; do
    if [[ ! -f "$file" ]]; then
        echo "대상 파일이 없습니다 (*.${source_ext})"
        exit 0
    fi

    newname="${file%.$source_ext}.$target_ext"

    if [[ -f "$newname" ]]; then
        echo "[SKIP] $file → $newname (이미 존재)"
        ((skipped++))
        continue
    fi

    cp "$file" "$newname"
    echo "[OK]   $file → $newname"
    ((count++))
done

echo "-----------------------------"
echo "완료: ${count}개 변환, ${skipped}개 건너뜀"