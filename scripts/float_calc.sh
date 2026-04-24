#!/bin/bash

# bc를 이용한 실수 계산
# scale=2는 소수점 이하 2자리
result=$(echo "scale=2; 10 / 3" | bc)
echo "10 / 3 = ${result}"    # 출력: 10 / 3 = 3.33

# 더 많은 자리
pi=$(echo "scale=10; 4 * a(1)" | bc -l)
echo "pi = ${pi}"            # 출력: pi = 3.1415926535

# 실용 예: 파일 크기를 MB로 변환
file_bytes=1572864
file_mb=$(echo "scale=2; ${file_bytes} / 1048576" | bc)
echo "파일 크기: ${file_mb} MB"    # 출력: 파일 크기: 1.50 MB

exit 0