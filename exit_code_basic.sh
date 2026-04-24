ls /tmp
echo "ls 종료 코드: $?"    # 성공이면 0 출력

ls /존재하지않는경로
echo "ls 종료 코드: $?"    # 실패이면 2 출력

grep "없는문자열" /etc/passwd
echo "grep 종료 코드: $?"  # 매치 없으면 1 출력