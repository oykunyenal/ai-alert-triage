# RB-004: Database backup failed

**Alert:** BackupFailed · **Priority:** P2 (one failed night), P1 (two nights in a row) · **Owner:** Backup and Business Continuity Team

## Symptom
The nightly `pg_dump` backup did not complete, or the backup file is much smaller than expected.

## Diagnosis
1. Size and date of recent backups: `ls -lh /opt/backups/ | tail`
2. Backup job log: `journalctl -u pg-backup --since yesterday`
3. Is the disk full? (RB-001)
4. Database connectivity: `docker compose exec postgres pg_isready`

## Resolution
- Take a backup by hand: `docker compose exec -T postgres pg_dump -U n8n -Fc n8n > /opt/backups/n8n_$(date +%F).dump`
- Always verify the backup: `pg_restore --list <file> | head` (is the file readable?)
- Send a copy of the backup to another location (Azure Blob Storage). 3-2-1 rule: 3 copies, 2 different media, 1 copy offsite.

## Note
A backup that has never been restored is not a backup. A restore test to a test environment is done once a month. The RPO target is 24 hours, the RTO target is 2 hours.

## Escalation
If it fails two nights in a row, notify the Backup Team Lead and the customer representative.
