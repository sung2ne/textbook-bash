#!/usr/bin/env bash

LOG_FILE="/var/log/myapp/app.log"
REPORT_DIR="$HOME/reports"
INTERVAL=60   # 60초마다 분석

mkdir -p "$REPORT_DIR"

echo "로그 모니터링 시작: $(date)"
echo "PID: $$"

count=0
while true; do
    count=$((count + 1))
    timestamp=$(date +%Y%m%d_%H%M%S)
    report_file="${REPORT_DIR}/report_${timestamp}.txt"

    echo "--- 분석 #${count}: $(date) ---" > "$report_file"

    if [[ -f "$LOG_FILE" ]]; then
        echo "ERROR 발생 횟수: $(grep -c ERROR "$LOG_FILE" 2>/dev/null || echo 0)" >> "$report_file"
        echo "최근 오류:" >> "$report_file"
        grep ERROR "$LOG_FILE" | tail -5 >> "$report_file" 2>/dev/null || true
    else
        echo "로그 파일 없음" >> "$report_file"
    fi

    echo "분석 완료: $report_file"
    sleep "$INTERVAL"
done