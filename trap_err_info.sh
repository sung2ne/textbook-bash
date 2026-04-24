#!/usr/bin/env bash
set -euo pipefail

error_handler() {
    local exit_code=$?
    local line_number=$1
    echo "" >&2
    echo "=============================" >&2
    echo " 오류 발생" >&2
    echo "=============================" >&2
    echo " 줄 번호 : ${line_number}" >&2
    echo " 종료 코드: ${exit_code}" >&2
    echo "=============================" >&2
}

# $LINENO를 인수로 전달 (trap 표현식에서 캡처)
trap 'error_handler ${LINENO}' ERR

echo "작업 1 시작"
cp /없는파일 /tmp/   # 오류 발생
echo "작업 2 시작"