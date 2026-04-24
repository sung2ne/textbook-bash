#!/bin/bash

target="${1}"
timeout="${2:-60}"

if [[ -z "$target" ]]; then
    echo "사용법: $0 <파일경로> [타임아웃초]"
    exit 1
fi

echo "대기 중: $target (최대 ${timeout}초)"

elapsed=0
until [[ -f "$target" ]]; do
    if [[ $elapsed -ge $timeout ]]; then
        echo "타임아웃: ${timeout}초 동안 파일이 생성되지 않았습니다."
        exit 1
    fi
    printf "\r경과: %d초 / 최대: %d초" $elapsed $timeout
    sleep 1
    ((elapsed++))
done

printf "\r                                    \r"
echo "파일 감지됨: $target"
echo "대기 시간: ${elapsed}초"