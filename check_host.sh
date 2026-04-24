#!/bin/bash

HOSTS=("8.8.8.8" "1.1.1.1" "google.com")
LOG_FILE="/var/log/ping_check.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

for host in "${HOSTS[@]}"; do
    if ping -c 1 -W 3 "$host" > /dev/null 2>&1; then
        echo "$TIMESTAMP $host: UP" | tee -a "$LOG_FILE"
    else
        echo "$TIMESTAMP $host: DOWN" | tee -a "$LOG_FILE"
    fi
done