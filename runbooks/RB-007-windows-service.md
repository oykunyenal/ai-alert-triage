# RB-007: Service stopped on a Windows server

**Priority:** P1 (critical business service), P2 (other) · **Owner:** Systems Administration Team (Windows)

## Symptom
A Windows service that should start automatically is in the "Stopped" state. Examples: IIS, SQL Server Agent, backup agent.

## Diagnosis (PowerShell)
1. Stopped automatic services: `Get-Service | Where-Object { $_.StartType -eq 'Automatic' -and $_.Status -ne 'Running' }`
2. Why the service stopped: `Get-WinEvent -LogName System -MaxEvents 50 | Where-Object { $_.ProviderName -eq 'Service Control Manager' }`
3. Dependent services: `Get-Service <name> -DependentServices`

## Resolution
- Start the service: `Start-Service -Name <name>`
- If it keeps stopping, the service account password may have changed or the account may be locked; check Active Directory.
- Service recovery setting: `sc.exe failure <name> reset= 86400 actions= restart/60000` (restart automatically 1 minute after the first failure).

## Escalation
If the service does not come up after 3 attempts, involve the application owner team.
