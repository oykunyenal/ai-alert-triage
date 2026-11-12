#!/usr/bin/env bash
# Sysadmin script: reports disks above a threshold as JSON.
# n8n can call this over SSH and use the result in a workflow.
# Usage: ./check-disk.sh [threshold_pct]   (default 80)
set -euo pipefail
THRESHOLD="${1:-80}"
echo "["
first=1
df -P -x tmpfs -x devtmpfs -x overlay | tail -n +2 | while read -r fs size used avail pct mount; do
  p="${pct%\%}"
  if [ "$p" -ge "$THRESHOLD" ]; then
    [ $first -eq 1 ] || echo ","
    first=0
    printf '  {"mount":"%s","usedPct":%s,"availKb":%s}' "$mount" "$p" "$avail"
  fi
done
echo
echo "]"
