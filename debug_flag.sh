#!/usr/bin/env bash

# DEBUG 환경변수가 설정되어 있으면 추적 활성화
[[ "${DEBUG:-}" ]] && set -x

echo "작업 시작"
RESULT=$(ls /tmp | wc -l)
echo "파일 수: $RESULT"
echo "완료"