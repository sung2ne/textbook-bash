#!/usr/bin/env bash
set -euo pipefail

# 롤백 명령어를 저장하는 배열
ROLLBACK_STACK=()

# 롤백 명령어 등록 함수
push_rollback() {
    ROLLBACK_STACK+=("$1")
}

# 롤백 실행 함수 (역순)
do_rollback() {
    echo "롤백 시작..." >&2
    local i
    for (( i=${#ROLLBACK_STACK[@]}-1; i>=0; i-- )); do
        echo "  실행: ${ROLLBACK_STACK[$i]}" >&2
        eval "${ROLLBACK_STACK[$i]}" || true
    done
    echo "롤백 완료" >&2
}

error_handler() {
    local exit_code=$?
    local line_number=$1
    echo "[ERROR] 줄 ${line_number}에서 오류 발생 (코드: ${exit_code})" >&2
    do_rollback
}

trap 'error_handler ${LINENO}' ERR

# ---- 배포 시뮬레이션 ----
echo "1. 설정 파일 백업"
cp /etc/hosts /tmp/hosts.bak
push_rollback "cp /tmp/hosts.bak /etc/hosts"

echo "2. 서비스 중지"
# systemctl stop myapp (실제 환경)
touch /tmp/myapp.stopped
push_rollback "rm -f /tmp/myapp.stopped"

echo "3. 파일 배포 (의도적 오류 발생)"
cp /없는_배포파일 /tmp/   # 오류!

echo "4. 서비스 시작 (여기까지 오지 않음)"