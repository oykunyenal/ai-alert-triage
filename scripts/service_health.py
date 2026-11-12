#!/usr/bin/env python3
"""Sysadmin script: returns the status of the compose services as JSON.

Can be called from n8n over SSH, or run from cron and post the result to a webhook.
Usage: python3 service_health.py [--webhook URL]
"""
import argparse, json, subprocess, sys, urllib.request

def services():
    out = subprocess.run(["docker", "compose", "-p", "gh-demo", "ps", "--all", "--format", "json"],
                         capture_output=True, text=True, check=True).stdout
    rows = [json.loads(l) for l in out.splitlines() if l.strip()]
    return [{"service": r.get("Service"), "state": r.get("State"), "health": r.get("Health") or None} for r in rows]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--webhook")
    args = ap.parse_args()
    items = services()
    unhealthy = [s for s in items if s["state"] != "running" or s["health"] == "unhealthy"]
    report = {"ok": not unhealthy, "unhealthy": unhealthy, "services": items}
    print(json.dumps(report, ensure_ascii=False, indent=2))
    if args.webhook and unhealthy:
        req = urllib.request.Request(args.webhook, data=json.dumps(report).encode(),
                                     headers={"Content-Type": "application/json"})
        urllib.request.urlopen(req, timeout=10)
    sys.exit(0 if not unhealthy else 2)

if __name__ == "__main__":
    main()
