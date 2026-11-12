#!/usr/bin/env bash
# For demos: SIMULATES an SSH brute-force attack.
# It does not attack anything; it only writes "Failed password" lines like sshd would
# to syslog (authpriv). Sentinel collects these logs and fires the rule.
# Usage: ./demo-brute-force.sh [attempt_count] [source_ip]
set -euo pipefail
COUNT="${1:-12}"
SRC_IP="${2:-203.0.113.45}"   # 203.0.113.0/24: reserved for documentation, not a real IP block
USERS=(admin root oracle test ubuntu)
for i in $(seq 1 "$COUNT"); do
  u="${USERS[$((i % ${#USERS[@]}))]}"
  logger -t sshd -p authpriv.info "Failed password for invalid user ${u} from ${SRC_IP} port $((40000 + i)) ssh2"
  sleep 1
done
echo "Wrote ${COUNT} simulated failed login log lines (source ${SRC_IP})."
