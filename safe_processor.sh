#!/usr/bin/env bash
# 용도: 로그 파일 대량 처리 (안전한 임시 파일 관리 실습)

set -euo pipefail

# ─── 설정 ─────────────────────────────────────────────────
SCRIPT_NAME=$(basename "$0" .sh)
PID_FILE="/tmp/${SCRIPT_NAME}.pid"
LOG_DIR="${1:-/var/log}"          # 처리할 로그 디렉토리 (기본: /var/log)
OUTPUT_FILE="${2:-./error_report_$(date +%Y%m%d).txt}"  # 출력 파일
PATTERN="ERROR"                   # 검색 패턴

# ─── 전역 변수 ───────────────────────────────────────────
TEMP_DIR=""
TOTAL_FILES=0
PROCESSED=0
ERRORS_FOUND=0
START_TIME=$(date +%s)

# ─── 유틸리티 함수 ───────────────────────────────────────
log() {
    echo "[$(date '+%H:%M:%S')] $*"
}

progress() {
    local current="$1"
    local total="$2"
    local file="$3"
    local percent=$(( current * 100 / total ))
    local bar_width=30
    local filled=$(( bar_width * percent / 100 ))
    local bar
    bar=$(printf '%0.s#' $(seq 1 "$filled") 2>/dev/null)
    bar+=$(printf '%0.s.' $(seq 1 $((bar_width - filled)) ) 2>/dev/null)
    printf "\r[%s] %3d%% (%d/%d) %s" "$bar" "$percent" "$current" "$total" "$file"
}

# ─── 클린업 함수 ─────────────────────────────────────────
cleanup() {
    local exit_code=$?

    echo ""   # 진행 표시줄 다음 줄로 이동

    log "정리 시작..."

    # 1. 임시 디렉토리 삭제
    if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
        log "임시 디렉토리 삭제 완료"
    fi

    # 2. PID 파일 삭제
    rm -f "$PID_FILE"

    # 3. 종료 통계
    local end_time
    end_time=$(date +%s)
    local elapsed=$((end_time - START_TIME))

    echo ""
    echo "===== 실행 결과 ====="
    echo "처리 파일: ${PROCESSED}/${TOTAL_FILES}개"
    echo "발견된 오류: ${ERRORS_FOUND}건"
    echo "소요 시간: ${elapsed}초"

    if [[ $exit_code -ne 0 ]]; then
        echo "상태: 비정상 종료 (코드: $exit_code)"
    else
        echo "상태: 정상 완료"
    fi
    echo "====================="

    exit "$exit_code"
}

trap cleanup EXIT

# ─── Ctrl+C 처리 ─────────────────────────────────────────
on_interrupt() {
    echo ""
    log "중단 요청을 받았습니다. 정리 후 종료합니다..."
    exit 130   # 관례: Ctrl+C 종료 코드
}

trap on_interrupt INT

# ─── 중복 실행 방지 ──────────────────────────────────────
if [[ -f "$PID_FILE" ]]; then
    existing_pid=$(cat "$PID_FILE")
    if kill -0 "$existing_pid" 2>/dev/null; then
        log "오류: 이미 실행 중입니다. (PID: $existing_pid)"
        log "중단하려면: kill $existing_pid"
        exit 1
    else
        log "경고: 이전 PID 파일 발견. 제거 후 계속합니다."
        rm -f "$PID_FILE"
    fi
fi

echo $$ > "$PID_FILE"
log "시작. PID: $$"

# ─── 임시 디렉토리 생성 ──────────────────────────────────
TEMP_DIR=$(mktemp -d --suffix=".processor")
log "임시 작업 디렉토리: $TEMP_DIR"

# ─── 처리할 파일 목록 수집 ───────────────────────────────
log "로그 파일 탐색 중: $LOG_DIR"
mapfile -t log_files < <(find "$LOG_DIR" -maxdepth 2 -name "*.log" -type f 2>/dev/null | sort)
TOTAL_FILES=${#log_files[@]}

if [[ $TOTAL_FILES -eq 0 ]]; then
    log "처리할 .log 파일이 없습니다: $LOG_DIR"
    exit 0
fi

log "총 ${TOTAL_FILES}개 파일 처리 시작"

# ─── 파일별 처리 (병렬 + 진행 표시) ─────────────────────
for log_file in "${log_files[@]}"; do
    PROCESSED=$((PROCESSED + 1))
    filename=$(basename "$log_file")
    progress "$PROCESSED" "$TOTAL_FILES" "$filename"

    # 임시 디렉토리에서 개별 결과 파일 생성
    result_file="${TEMP_DIR}/${PROCESSED}.result"

    # ERROR 패턴 추출 (파일이 없거나 권한 없으면 건너뜀)
    if error_lines=$(grep "$PATTERN" "$log_file" 2>/dev/null); then
        count=$(echo "$error_lines" | wc -l)
        ERRORS_FOUND=$((ERRORS_FOUND + count))

        {
            echo "=== $log_file (${count}건) ==="
            echo "$error_lines"
            echo ""
        } > "$result_file"
    fi
done

echo ""   # 진행 표시줄 후 줄바꿈

# ─── 결과 취합 ───────────────────────────────────────────
log "결과 취합 중..."

{
    echo "로그 오류 분석 보고서"
    echo "생성 시각: $(date)"
    echo "분석 대상: $LOG_DIR"
    echo "총 파일: ${TOTAL_FILES}개"
    echo "총 오류: ${ERRORS_FOUND}건"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # 개별 결과 파일들을 순서대로 합치기
    for result_file in "${TEMP_DIR}"/*.result; do
        [[ -f "$result_file" ]] && cat "$result_file"
    done
} > "$OUTPUT_FILE"

log "보고서 저장 완료: $OUTPUT_FILE"