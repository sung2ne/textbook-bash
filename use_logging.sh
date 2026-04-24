#!/usr/bin/env bash

# 로깅 라이브러리 로드
# shellcheck source=lib_logging.sh
source "$(dirname "$0")/lib_logging.sh"

# 환경변수로 설정 제어
# LOG_LEVEL=DEBUG ./use_logging.sh
# LOG_FILE=/tmp/app.log ./use_logging.sh

log_info  "애플리케이션 시작"
log_debug "디버그 모드 정보 (LOG_LEVEL=DEBUG일 때만 출력)"
log_warn  "디스크 사용량 높음"
log_error "파일을 찾을 수 없습니다"

log_info  "처리 완료"