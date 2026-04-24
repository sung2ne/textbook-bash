#!/bin/bash
# 이 스크립트를 실행할 때 인자를 넘겨주세요
# 예: bash scripts/special_vars.sh 홍길동 25 서울

echo "스크립트 이름: $0"
echo "첫 번째 인자: $1"
echo "두 번째 인자: $2"
echo "세 번째 인자: $3"
echo "인자 개수: $#"
echo "현재 PID: $$"

echo ""
echo "모든 인자 (\$@):"
for arg in "$@"; do
  echo "  - ${arg}"
done

echo ""
echo "모든 인자 (\$*):"
for arg in "$*"; do
  echo "  - ${arg}"
done

exit 0