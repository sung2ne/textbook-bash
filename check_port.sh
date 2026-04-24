#!/bin/bash

HOST="${1:-localhost}"
PORT="${2:-80}"
TIMEOUT=5

if timeout "$TIMEOUT" bash -c "echo > /dev/tcp/$HOST/$PORT" 2>/dev/null; then
    echo "$HOST:$PORT 연결 가능"
    exit 0
else
    echo "$HOST:$PORT 연결 불가"
    exit 1
fi