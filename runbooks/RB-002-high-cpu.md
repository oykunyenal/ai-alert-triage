# RB-002: High CPU usage (HighCpuLoad)

**Alert:** HighCpuLoad · **Priority:** P2 · **Owner:** Systems Administration Team

## Symptom
CPU usage has been above 85% for more than 3 minutes. Response times grow and scheduled jobs are delayed.

## Diagnosis
1. Processes using the most CPU: `top -o %CPU` or `ps aux --sort=-%cpu | head -15`
2. Per container: `docker stats --no-stream`
3. CPU credits (Azure B-series VMs): Portal → VM → Metrics → "CPU Credits Remaining". When credits run out, the VM drops to baseline performance.
4. Check the time of the last deploy; if the increase started after a deploy, suspect the new version.

## Resolution
- If a single runaway process is the cause, restart the related service: `docker compose restart <service>`
- If caused by a deploy, roll back: re-run the previous successful pipeline run in Azure DevOps.
- If it stays high: resize the VM or split the workload.

## Escalation
If customers report slowness, raise to P1 and involve the application team.
