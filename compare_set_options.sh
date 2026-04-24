#!/usr/bin/env bash

# 1. set 옵션 없이 실행
echo "=== set 옵션 없음 ==="
(
    TYPO_VAR="hello"
    echo "미정의 변수: $TYPO_VAP"   # 오타 변수 → 빈 문자열
    ls /없는경로                     # 실패 → 무시
    cat /없는파일 | sort              # cat 실패 → sort는 성공
    echo "파이프라인 종료 코드: $?"  # 0 출력
    echo "스크립트 계속 실행"
)

echo ""

# 2. set -euo pipefail로 실행
echo "=== set -euo pipefail ==="
(
    set -euo pipefail

    TYPO_VAR="hello"
    # echo "미정의 변수: $TYPO_VAP"  # 주석 해제하면 즉시 오류
    ls /없는경로 2>/dev/null || echo "ls 실패 (무시하고 계속)"
    
    # 파이프라인 실패 감지
    if cat /없는파일 2>/dev/null | sort; then
        echo "파이프라인 성공"
    else
        echo "파이프라인 실패 감지됨 (종료 코드: $?)"
    fi
    
    echo "set -euo pipefail 구간 완료"
)

echo ""
echo "비교 완료"