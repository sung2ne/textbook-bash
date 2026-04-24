#!/usr/bin/env bash

cp /없는파일 /tmp/   # 실패
echo "이 줄도 실행됩니다."   # set -e 없이는 실행됨
echo "끝"