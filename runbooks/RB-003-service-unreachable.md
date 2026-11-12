# RB-003: Service unreachable (TargetDown)

**Alert:** TargetDown · **Priority:** P1 · **Owner:** Systems Administration Team

## Symptom
Prometheus has not been able to scrape a target for 1 minute. The service may have crashed, be restarting, or have lost network access.

## Diagnosis
1. Container states: `cd /opt/gh-demo && docker compose ps`
2. Container stuck restarting: `docker compose logs --tail 100 <service>`
3. Resource problem: `docker inspect <container> --format '{{.State.OOMKilled}}'` (did it run out of memory?)
4. Health check: `curl -fsS https://<domain>/healthz`
5. Is the disk full? (RB-001)

## Resolution
- If a single service is down: `docker compose up -d <service>`
- Configuration error (after the last deploy): go back to the previous commit and run the pipeline.
- If memory is insufficient: set a memory limit on the container or resize the VM.
- If the database (postgres) is down, first confirm the backup from RB-004 is current, then restart it.

## Escalation
If it is not back up within 5 minutes, notify the on-call engineer and the service owner.
