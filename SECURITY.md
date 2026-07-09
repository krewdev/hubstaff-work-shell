# Security Policy

## What this project does

`hs` is a local shell wrapper. It:

- Invokes the official `HubstaffCLI` binary inside `Hubstaff.app`
- May quit the Hubstaff process when you request stop/guard
- Writes state under `~/.config/hubstaff-work/` (no secrets by design)

It does **not** implement Hubstaff’s network protocol or store account passwords.

## Reporting a vulnerability

If you find a security issue in **this repository’s scripts** (e.g. unsafe path handling, unexpected code execution):

1. Open a private report if the host supports it, or
2. Open a GitHub issue without exploit details and ask for a secure contact channel.

Please do **not** file issues that request help spoofing Hubstaff or bypassing employer monitoring while the timer is on.

## Secrets and local data

Never commit:

- Hubstaff tokens or `account.json` from `~/Library/Application Support/Hubstaff/`
- Cloudflare / VPN / other credentials
- Real org IDs if your org considers them sensitive (optional redaction in bug reports)

## Dependencies

There are no third-party package dependencies. Review `bin/hs` and `install.sh` before installing.
