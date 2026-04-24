#!/usr/bin/env bash

echo "병렬 처리 시작: $(date)"

# 세 가지 작업을 동시에 시작
(sleep 3 && echo "작업 A 완료") &
PID_A=$!

(sleep 1 && echo "작업 B 완료") &
PID_B=$!

(sleep 2 && echo "작업 C 완료") &
PID_C=$!

echo "세 작업 실행 중..."

# 특정 PID 대기
wait $PID_B
echo "B가 먼저 끝났습니다."

# 모든 백그라운드 작업 대기
wait
echo "모든 작업 완료: $(date)"