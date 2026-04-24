#!/bin/bash

echo "--- \$@ 사용 ---"
for arg in "$@"; do
  echo "  항목: [${arg}]"
done

echo ""
echo "--- \$* 사용 ---"
for arg in "$*"; do
  echo "  항목: [${arg}]"
done

exit 0