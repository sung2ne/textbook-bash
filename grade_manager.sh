#!/bin/bash
# grade_manager.sh — 학생 성적 관리 프로그램

# 라이브러리 로드
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "${SCRIPT_DIR}/lib_utils.sh"

# === 데이터 ===
# 연관 배열: 학생 이름 → 점수
declare -A grades

# 입력 순서를 보존하기 위한 이름 목록
student_order=()

# === 함수 정의 ===

# 1) 성적 입력
add_score() {
    local name score

    echo ""
    read -rp "학생 이름을 입력하세요: " name

    if [[ -z "$name" ]]; then
        log_warn "이름을 입력하지 않았습니다."
        return 1
    fi

    read -rp "${name}의 점수를 입력하세요 (0~100): " score

    # 숫자 유효성 검사
    if ! [[ "$score" =~ ^[0-9]+$ ]] || (( score < 0 || score > 100 )); then
        log_error "유효하지 않은 점수입니다: $score"
        return 1
    fi

    # 이미 있으면 덮어씀, 없으면 순서 목록에 추가
    if [[ ! -v grades["$name"] ]]; then
        student_order+=("$name")
    fi

    grades["$name"]=$score
    log_info "${name}: ${score}점 저장 완료."
}

# 2) 성적 조회
show_scores() {
    if (( ${#grades[@]} == 0 )); then
        log_warn "저장된 성적이 없습니다."
        return
    fi

    echo ""
    print_header "성적 목록"
    printf "  %-15s %5s  %s\n" "이름" "점수" "등급"
    print_separator

    for name in "${student_order[@]}"; do
        local score="${grades[$name]}"
        local grade

        # 등급 계산
        if (( score >= 90 )); then
            grade="A"
        elif (( score >= 80 )); then
            grade="B"
        elif (( score >= 70 )); then
            grade="C"
        elif (( score >= 60 )); then
            grade="D"
        else
            grade="F"
        fi

        # 점수에 따라 색상 표시
        if (( score >= 90 )); then
            printf "  %-15s " "$name"
            print_green "$(printf '%3d점  %s' "$score" "$grade")"
        elif (( score < 60 )); then
            printf "  %-15s " "$name"
            print_red "$(printf '%3d점  %s' "$score" "$grade")"
        else
            printf "  %-15s %3d점  %s\n" "$name" "$score" "$grade"
        fi
    done

    print_separator
    echo "  총 ${#grades[@]}명"
}

# 3) 평균 계산
calc_average() {
    if (( ${#grades[@]} == 0 )); then
        log_warn "저장된 성적이 없습니다."
        return
    fi

    local total=0
    local count=${#grades[@]}

    for name in "${!grades[@]}"; do
        (( total += grades["$name"] ))
    done

    # Bash는 정수 나눗셈만 지원 → awk로 소수점 계산
    local average
    average=$(awk "BEGIN { printf \"%.2f\", $total / $count }")

    echo ""
    log_info "총점: ${total}점 / 학생 수: ${count}명"
    log_info "평균: ${average}점"
}

# 4) 최고점/최저점
show_stats() {
    if (( ${#grades[@]} == 0 )); then
        log_warn "저장된 성적이 없습니다."
        return
    fi

    local max_score=-1
    local min_score=101
    local max_name=""
    local min_name=""

    for name in "${!grades[@]}"; do
        local score="${grades[$name]}"

        if (( score > max_score )); then
            max_score=$score
            max_name=$name
        fi

        if (( score < min_score )); then
            min_score=$score
            min_name=$name
        fi
    done

    echo ""
    print_header "최고점 / 최저점"
    printf "  최고점: %-15s " "$max_name"
    print_green "${max_score}점"
    printf "  최저점: %-15s " "$min_name"
    print_red "${min_score}점"
    print_separator
}

# 5) 메뉴 출력
show_menu() {
    echo ""
    print_separator
    echo "  학생 성적 관리 프로그램"
    print_separator
    echo "  1) 성적 입력"
    echo "  2) 성적 조회"
    echo "  3) 평균 계산"
    echo "  4) 최고점 / 최저점"
    echo "  5) 종료"
    print_separator
    echo -n "  선택: "
}

# === 메인 루프 ===
main() {
    log_info "성적 관리 프로그램을 시작합니다."

    while true; do
        show_menu
        read -r choice

        case "$choice" in
            1) add_score ;;
            2) show_scores ;;
            3) calc_average ;;
            4) show_stats ;;
            5)
                echo ""
                log_info "프로그램을 종료합니다."
                exit 0
                ;;
            *)
                log_warn "잘못된 선택입니다: $choice"
                ;;
        esac
    done
}

main