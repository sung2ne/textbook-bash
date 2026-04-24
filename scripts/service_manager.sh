#!/bin/bash

SERVICE="${1:-nginx}"

echo "=============================="
echo "  서비스 관리: $SERVICE"
echo "=============================="

PS3="동작을 선택하세요: "

select action in "상태 확인" "시작" "중지" "재시작" "로그 보기" "종료"; do
    case $action in
        "상태 확인")
            echo ""
            echo "--- $SERVICE 상태 ---"
            systemctl status "$SERVICE" 2>/dev/null || echo "(systemctl 사용 불가: 시뮬레이션 모드)"
            echo ""
            ;;
        "시작")
            echo ""
            echo "sudo systemctl start $SERVICE"
            echo "(실행하려면 sudo 권한이 필요합니다)"
            echo ""
            ;;
        "중지")
            echo ""
            echo "sudo systemctl stop $SERVICE"
            echo "(실행하려면 sudo 권한이 필요합니다)"
            echo ""
            ;;
        "재시작")
            echo ""
            echo "sudo systemctl restart $SERVICE"
            echo "(실행하려면 sudo 권한이 필요합니다)"
            echo ""
            ;;
        "로그 보기")
            echo ""
            echo "--- 최근 로그 (20줄) ---"
            journalctl -u "$SERVICE" -n 20 --no-pager 2>/dev/null || echo "(journalctl 사용 불가)"
            echo ""
            ;;
        "종료")
            echo "관리 메뉴를 종료합니다."
            break
            ;;
        "")
            echo "잘못된 선택입니다: '$REPLY'. 1-6 사이의 번호를 입력하세요."
            ;;
    esac
done