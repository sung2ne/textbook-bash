#!/usr/bin/env bash

LOG_FILE="/tmp/myscript_$(date '+%Y%m%d').log"

# 모든 출력(stdout + stderr)을 파일로도 저장
exec > >(tee -a "$LOG_FILE") 2>&1

echo "이 메시지는 화면과 파일에 모두 출력됩니다."
ls /없는경로   # 에러 메시지도 파일에 저장됨
echo "완료"