#!/bin/bash

ls /tmp
echo "ls 종료 코드: $?"    # 성공이면 0

ls /존재하지않는디렉토리
echo "ls 종료 코드: $?"    # 실패이면 2

exit 0