#!/usr/bin/env bash

START_TIME=$(date +%s)
PROCESSED=0

finish() {
    local end_time
    end_time=$(date +%s)
    local elapsed=$((end_time - START_TIME))

    echo ""
    echo "===== 작업 결과 ====="
    echo "처리 건수: $PROCESSED"
    echo "소요 시간: ${elapsed}초"
    echo "종료 시각: $(date)"
    echo "===================="
}

trap finish EXIT

# 가상 작업 수행
for i in {1..10}; do
    echo "항목 $i 처리 중..."
    PROCESSED=$((PROCESSED + 1))
    sleep 0.5
done