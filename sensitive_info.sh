#!/usr/bin/env bash
set -euo pipefail

# 위험: 비밀번호를 환경변수나 명령줄 인수로 전달
# mysql -u root -p"$DB_PASSWORD" mydb   # ps로 비밀번호 노출

# 안전: 설정 파일로 자격증명 전달
connect_db() {
    local config_file="$1"
    mysql --defaults-file="$config_file" mydb
}

# 위험: 비밀번호를 로그에 출력
# echo "연결: mysql://$DB_USER:$DB_PASSWORD@$DB_HOST"

# 안전: 민감 정보 마스킹
log_connection() {
    local user="$1"
    local host="$2"
    echo "연결: mysql://${user}:***@${host}"   # 비밀번호 마스킹
}

# 히스토리에서 민감한 명령어 제외
# 명령어 앞에 공백을 붙이면 히스토리에 저장되지 않음 (HISTCONTROL=ignorespace)
# 또는 HISTIGNORE 패턴 설정