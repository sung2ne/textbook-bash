#!/bin/bash

echo "구구단 (5의 배수 결과 건너뜀, 50 이상이면 해당 단 중단)"
echo "============================================================"

for ((i=2; i<=9; i++)); do
    echo "--- ${i}단 ---"
    for ((j=1; j<=9; j++)); do
        result=$((i * j))

        if [[ $result -ge 50 ]]; then
            echo "  ${i} × ${j} = ${result} (50 이상, 중단)"
            break   # 안쪽 루프 탈출
        fi

        if [[ $((result % 5)) -eq 0 ]]; then
            echo "  ${i} × ${j} = ${result} (5의 배수, 건너뜀)"
            continue
        fi

        echo "  ${i} × ${j} = ${result}"
    done
done