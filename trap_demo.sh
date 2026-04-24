#!/usr/bin/env bash

set -uo pipefail

count=0
interrupted=false

on_interrupt() {
    echo ""
    echo "중단 요청을 받았습니다."
    echo "현재까지 처리한 항목: $count"
    interrupted=true
}

on_exit() {
    if $interrupted; then
        echo "사용자에 의해 중단되었습니다."
    else
        echo "정상 완료."
    fi
    echo "총 처리: $count건"
}

trap on_interrupt INT
trap on_exit EXIT

echo "작업 시작. Ctrl+C로 중단할 수 있습니다."

while true; do
    count=$((count + 1))
    echo "처리 중: $count..."
    sleep 1
    $interrupted && break
done