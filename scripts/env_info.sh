#!/bin/bash

echo "사용자: ${USER}"
echo "홈 디렉토리: ${HOME}"
echo "쉘: ${SHELL}"
echo "현재 디렉토리: ${PWD}"
echo "이전 디렉토리: ${OLDPWD:-없음}"

echo ""
echo "PATH 항목들:"
# PATH를 콜론으로 분리해서 각 줄에 출력
echo "${PATH//:/$'\n'}"

exit 0