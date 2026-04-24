#!/usr/bin/env bash
set -e

cp /없는파일 /tmp/   # 실패
echo "이 줄은 실행되지 않습니다."   # set -e로 여기 오기 전에 종료
echo "끝"