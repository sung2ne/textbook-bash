#!/bin/bash

# ${var:-default}: var가 비어있으면 default 사용 (var는 변경 안됨)
username="${1:-guest}"
echo "사용자: ${username}"

# ${var:=default}: var가 비어있으면 default를 var에 저장하고 사용
: "${log_level:=INFO}"
echo "로그 레벨: ${log_level}"

# ${var:+alt}: var가 설정되어 있으면 alt 사용
debug_flag="true"
echo "디버그: ${debug_flag:+[DEBUG 활성화됨]}"

# ${var:?error}: var가 비어있으면 오류 메시지 출력 후 종료
: "${REQUIRED_VAR:?필수 환경변수 REQUIRED_VAR이 설정되지 않았습니다}"

exit 0