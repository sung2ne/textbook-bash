#!/bin/bash

PASS=0
FAIL=0

check() {
    local desc="$1"
    local result="$2"
    if [[ "$result" == "ok" ]]; then
        echo "[OK]   $desc"
        ((PASS++))
    else
        echo "[FAIL] $desc → $result"
        ((FAIL++))
    fi
}

echo "=============================="
echo "  시스템 점검 시작"
echo "=============================="

# 필수 파일 확인
if [[ -f /etc/hosts ]]; then
    check "/etc/hosts 존재" "ok"
else
    check "/etc/hosts 존재" "파일 없음"
fi

if [[ -r /etc/hosts ]]; then
    check "/etc/hosts 읽기 권한" "ok"
else
    check "/etc/hosts 읽기 권한" "권한 없음"
fi

# 홈 디렉토리 확인
if [[ -d "$HOME" ]]; then
    check "홈 디렉토리 ($HOME) 존재" "ok"
else
    check "홈 디렉토리 존재" "없음"
fi

if [[ -w "$HOME" ]]; then
    check "홈 디렉토리 쓰기 권한" "ok"
else
    check "홈 디렉토리 쓰기 권한" "권한 없음"
fi

# /tmp 확인
if [[ -d /tmp && -w /tmp ]]; then
    check "/tmp 쓰기 가능" "ok"
else
    check "/tmp 쓰기 가능" "실패"
fi

# 환경변수 확인
if [[ -n "$HOME" ]]; then
    check "\$HOME 설정됨 ($HOME)" "ok"
else
    check "\$HOME 설정됨" "미설정"
fi

if [[ -n "$PATH" ]]; then
    check "\$PATH 설정됨" "ok"
else
    check "\$PATH 설정됨" "미설정"
fi

# 파일 크기 확인
logfile="/var/log/syslog"
if [[ -f "$logfile" ]]; then
    if [[ -s "$logfile" ]]; then
        size=$(du -sh "$logfile" 2>/dev/null | cut -f1)
        check "$logfile 크기 ($size)" "ok"
    else
        check "$logfile 크기" "빈 파일"
    fi
else
    check "$logfile 존재" "파일 없음"
fi

echo "=============================="
echo "결과: 통과 ${PASS}개, 실패 ${FAIL}개"
echo "=============================="

[[ $FAIL -eq 0 ]] && exit 0 || exit 1