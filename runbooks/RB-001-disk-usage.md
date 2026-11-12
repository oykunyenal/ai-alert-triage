# RB-001: High disk usage (HighDiskUsage)

**Alert:** HighDiskUsage · **Priority:** P1 (above 90%), P2 (80–90%) · **Owner:** Systems Administration Team

## Symptom
Root disk (/) usage went above 80%. Above 95%, database and log writes stop and services crash.

## Diagnosis
1. Confirm usage: `df -h /`
2. Find the largest directories: `sudo du -xh / --max-depth=2 2>/dev/null | sort -h | tail -20`
3. See how much space Docker uses: `docker system df`
4. Check for deleted files still held open: `sudo lsof -nP +L1`
5. Find large log files: `sudo find /var/log -type f -size +100M -exec ls -lh {} \;`

## Resolution
- Old Docker images and build cache: `docker image prune -a -f` and `docker builder prune -f` (does not affect running containers).
- Shrink the systemd journal: `sudo journalctl --vacuum-size=200M`
- Application logs: check the logrotate configuration, and if needed run `sudo logrotate -f /etc/logrotate.conf`.
- If deleted files are held open, restart the related service.
- If a permanent fix is needed, grow the disk: in Azure `az disk update --size-gb`, then extend the file system.

## Do not
- Delete database files (`/var/lib/docker/volumes/*pg_data*`) by hand.
- Only grow the disk without finding the cause; the problem will come back.

## Escalation
Above 95%, or not resolved within 30 minutes: on-call infrastructure engineer → infrastructure team lead.
