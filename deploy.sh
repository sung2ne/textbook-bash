#!/usr/bin/env bash

# cron 환경을 위해 명시적으로 설정
export PATH="/usr/local/bin:/usr/bin:/bin"
export HOME="/home/ubuntu"
source /home/ubuntu/.profile 2>/dev/null || true

# 이하 작업...