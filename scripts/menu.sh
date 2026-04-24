#!/bin/bash

echo "============================="
echo "  패키지 관리 메뉴"
echo "============================="
echo "1) 설치"
echo "2) 삭제"
echo "3) 업데이트"
echo "q) 종료"
echo "============================="
echo -n "선택: "
read choice

case $choice in
    1)
        echo -n "설치할 패키지 이름: "
        read pkg
        echo "sudo apt install $pkg 실행 중..."
        ;;
    2)
        echo -n "삭제할 패키지 이름: "
        read pkg
        echo "sudo apt remove $pkg 실행 중..."
        ;;
    3)
        echo "패키지 목록 갱신 및 업그레이드 실행 중..."
        echo "sudo apt update && sudo apt upgrade"
        ;;
    q|Q)
        echo "종료합니다."
        exit 0
        ;;
    *)
        echo "잘못된 선택입니다: '$choice'"
        exit 1
        ;;
esac

echo "작업 완료."