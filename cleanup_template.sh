#!/usr/bin/env bash

set -euo pipefail

# --- 전역 변수 ---
TEMP_DIR=""
PID_FILE="/tmp/$(basename "$0" .sh).pid"
SCRIPT_NAME=$(basename "$0")
LOG_FILE="/tmp/${SCRIPT_NAME%.sh}.log"

# --- 로그 함수 ---
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

# --- 클린업 함수 ---
cleanup() {
    local exit_code=$?
    log "정리 시작 (종료 코드: $exit_code)"

    [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]] && rm -rf "$TEMP_DIR"
    rm -f "$PID_FILE"

    log "정리 완료"
    exit "$exit_code"
}

trap cleanup EXIT

# --- 중복 실행 방지 ---
if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    log "오류: 이미 실행 중입니다."
    exit 1
fi
echo $$ > "$PID_FILE"

# --- 메인 작업 ---
TEMP_DIR=$(mktemp -d)
log "작업 시작. 임시 디렉토리: $TEMP_DIR"

# 여기에 실제 작업 코드 작성

log "작업 완료"