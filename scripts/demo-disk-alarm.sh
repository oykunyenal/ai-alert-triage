#!/usr/bin/env bash
# For demos: fills the disk to trigger the HighDiskUsage alert, then cleans up.
# Usage: ./demo-disk-alarm.sh fill   |   ./demo-disk-alarm.sh clean
set -euo pipefail
FILE=/var/tmp/demo-disk.fill
case "${1:-}" in
  fill)
    avail_kb=$(df -Pk / | awk 'NR==2{print $4}'); size_kb=$(df -Pk / | awk 'NR==2{print $2}')
    target_kb=$(( size_kb * 85 / 100 - (size_kb - avail_kb) ))
    [ "$target_kb" -gt 0 ] || { echo "Disk is already above 85%"; exit 0; }
    sudo fallocate -l "${target_kb}K" "$FILE"; df -h / ;;
  clean)
    sudo rm -f "$FILE"; df -h / ;;
  *) echo "Usage: $0 fill|clean"; exit 1 ;;
esac
