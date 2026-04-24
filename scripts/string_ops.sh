#!/bin/bash

greeting="Hello, World!"

# 문자열 길이
echo "길이: ${#greeting}"           # 출력: 길이: 13

# 부분 추출 ${var:offset:length}
echo "앞 5자: ${greeting:0:5}"      # 출력: 앞 5자: Hello
echo "뒤에서: ${greeting:7}"        # 출력: 뒤에서: World!

# 문자열 연결
first="Hello"
second="World"
combined="${first}, ${second}!"
echo "${combined}"                  # 출력: Hello, World!

# 문자열 치환 ${var/패턴/대체}
path="/home/user/documents/file.txt"
echo "${path/user/ibetter}"         # 출력: /home/ibetter/documents/file.txt

# 대소문자 변환 (Bash 4.0+)
text="Hello World"
echo "${text,,}"    # 소문자: hello world
echo "${text^^}"    # 대문자: HELLO WORLD

exit 0