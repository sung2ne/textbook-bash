#!/usr/bin/env bash

set -euo pipefail

RESULT_DIR=$(mktemp -d)
DIRS=("/usr/bin" "/usr/lib" "/etc")

echo "디렉토리별 파일 통계 수집 시작"

# 각 디렉토리를 백그라운드로 분석
pids=()
for dir in "${DIRS[@]}"; do
    (
        count=$(find "$dir" -maxdepth 1 -type f 2>/dev/null | wc -l)
        size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        echo "$dir: 파일 ${count}개, 크기 ${size}"
    ) > "${RESULT_DIR}/$(basename "$dir").txt" &
    pids+=($!)
done

# 모든 작업 완료 대기
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo ""
echo "===== 통계 결과 ====="
cat "${RESULT_DIR}"/*.txt

# 임시 디렉토리 정리
rm -rf "$RESULT_DIR"
echo ""
echo "완료"