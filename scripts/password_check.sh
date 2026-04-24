#!/bin/bash

readonly CORRECT_PASSWORD="bash2026"

read -sp "비밀번호를 입력하세요: " input_password
echo ""    # 줄바꿈

if [[ "${input_password}" == "${CORRECT_PASSWORD}" ]]; then
  echo "인증 성공! 환영합니다."
  exit 0
else
  echo "비밀번호가 틀렸습니다."
  exit 1
fi