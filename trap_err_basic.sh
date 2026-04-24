#!/usr/bin/env bash
set -euo pipefail

on_error() {
    echo "오류가 발생했습니다!" >&2
    echo "종료 코드: $?" >&2
}

trap on_error ERR

echo "정상 명령어 실행"
ls /없는경로          # 오류 발생 → on_error 실행
echo "이 줄은 실행되지 않습니다."