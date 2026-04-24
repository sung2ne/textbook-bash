#!/usr/bin/env bash

# 방법 1: SECONDS 변수 (초 단위, 소수점 없음)
SECONDS=0
# ... 작업 수행 ...
sleep 2
echo "경과 시간: ${SECONDS}초"   # 2초

# 방법 2: date +%s%N (나노초 단위, 밀리초까지 측정 가능)
start_ns=$(date +%s%N)
# ... 작업 수행 ...
sleep 1
end_ns=$(date +%s%N)
elapsed_ms=$(( (end_ns - start_ns) / 1000000 ))
echo "경과 시간: ${elapsed_ms}ms"   # 약 1000ms

# 방법 3: 구간별 측정
benchmark() {
    local label="$1"
    local start=$SECONDS
    shift
    "$@"   # 전달받은 명령어 실행
    echo "[benchmark] ${label}: $((SECONDS - start))초"
}

benchmark "파일 정렬" sort -u /etc/passwd -o /tmp/sorted.txt
benchmark "단어 빈도" awk '{for(i=1;i<=NF;i++) freq[$i]++} END{for(w in freq) print freq[w],w}' /etc/passwd