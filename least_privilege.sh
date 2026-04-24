#!/usr/bin/env bash

# root 권한이 필요한지 확인
if [[ $EUID -eq 0 ]]; then
    echo "경고: root로 실행 중입니다. 가능하면 일반 사용자로 실행하세요." >&2
fi

# 특정 작업에만 sudo 사용
# 전체 스크립트를 root로 실행하는 대신 필요한 명령어만 sudo
regular_task() {
    echo "일반 작업: 권한 불필요"
    ls /tmp
}

privileged_task() {
    echo "권한 필요한 작업"
    sudo systemctl restart nginx   # 이 명령어만 sudo
}

regular_task
privileged_task
regular_task   # 다시 일반 권한으로