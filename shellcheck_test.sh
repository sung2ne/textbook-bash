#!/bin/bash

process_files() {
    local dir=$1
    local result=$(ls $dir)   # SC2046, SC2086, SC2155
    for file in $result; do   # SC2086
        if [ $? -eq 0 ]; then  # SC2181 (이전 명령어 없음)
            echo $file         # SC2086
        fi
    done
}

read input                    # SC2162
process_files $input          # SC2086