# RB-006: Automation workflow failing (n8n)

**Priority:** P2 · **Owner:** Automation / Integration Team

## Symptom
An n8n workflow ends in the "Error" state, expected notifications do not arrive, or "Alert Without Summary" messages increase.

## Diagnosis
1. n8n → the workflow → **Executions** tab: which node failed?
2. If it is an LLM error: in the Azure portal, check the Foundry resource → quota (429), deployment name and API key validity.
3. If it is a credential error (401/403): the credential may have expired or been revoked.
4. Telegram "can't parse entities": special characters in the message were not escaped.
5. n8n container logs: `docker compose logs --tail 100 n8n`

## Resolution
- For transient LLM errors the workflow already tries twice and, if it still fails, sends a notification without a summary; the alert is not lost.
- For a persistent LLM problem: raise the Foundry quota or define a fallback model.
- If a credential was renewed, update it in n8n and **Publish** the workflow again.

## Escalation
If the alert workflow has been down for more than 15 minutes, the on-call engineer follows alerts directly in Grafana.
