# RB-005: TLS certificate expiring / HTTPS error

**Priority:** P1 (expired), P3 (less than 14 days left) · **Owner:** Systems Administration Team

## Symptom
Certificate error in the browser, `SSL certificate problem` or `tlsv1 alert internal error` in `curl` calls.

## Diagnosis
1. Certificate expiry date: `echo | openssl s_client -connect <domain>:443 -servername <domain> 2>/dev/null | openssl x509 -noout -dates`
2. Caddy logs: `docker compose logs --tail 100 caddy | grep -i -E "certificate|acme|error"`
3. Are ports 80 and 443 open from outside? (Let's Encrypt validation needs port 80.) Check the Azure NSG rules.
4. Does the DNS record point to the right IP: `dig +short <domain>`

## Resolution
- Caddy renews the certificate automatically. If it cannot, the cause is usually a closed port or wrong DNS; fix those and run `docker compose restart caddy`.
- A few minutes of TLS errors right after a fresh install are normal: the certificate is being issued.

## Escalation
If the certificate of a customer-facing service has expired, it is P1 and the network team is involved.
