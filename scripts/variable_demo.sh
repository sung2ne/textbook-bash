#!/bin/bash

name="ibetter"
version="5"

# $name 방식
echo "사용자: $name"

# ${name} 방식 (중괄호로 경계를 명확히)
echo "버전: ${version}번째"

# 중괄호가 없으면 변수명이 잘못 해석됨
echo "버전: $version번째"    # 이건 동작하지만
echo "버전: $version_release"  # 이건 version_release 변수를 찾음 (비어있음!)

# 올바른 방법
echo "버전: ${version}_release"

exit 0