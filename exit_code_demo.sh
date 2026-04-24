# 127: 존재하지 않는 명령어
nonexistent_command 2>/dev/null
echo "존재하지 않는 명령어: $?"   # 127

# 126: 실행 권한 없음
touch /tmp/no_exec.sh
bash /tmp/no_exec.sh 2>/dev/null
echo "실행 권한 없음: $?"         # 126 또는 1 (버전에 따라 다름)

# 130: Ctrl+C (SIGINT, 128+2)
# sleep 10 실행 중 Ctrl+C를 누르면 종료 코드가 130