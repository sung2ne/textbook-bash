#!/usr/bin/env bash

# 방법 1: xargs -P (병렬 프로세스 개수 지정)
# CPU 코어 수만큼 병렬로 파일 압축
find /tmp/logs -name "*.log" | xargs -P 4 -I{} gzip {}

# 방법 2: GNU Parallel (더 세밀한 제어)
# parallel이 설치되어 있는 경우
# find /tmp/logs -name "*.log" | parallel -j4 gzip {}

# 예시: 10개 URL을 4개씩 병렬로 다운로드
urls=(
    "https://example.com/file1.txt"
    "https://example.com/file2.txt"
    # ...
)

printf '%s\n' "${urls[@]}" | xargs -P 4 -I{} curl -sO {}