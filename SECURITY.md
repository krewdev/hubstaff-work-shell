# Security Policy

## Supported versions

| Version | Supported |
|---------|-----------|
| 0.1.x   | Yes |

## What this project does

`hs` is a local shell wrapper around the official **HubstaffCLI** inside Hubstaff.app. It does not implement Hubstaff’s network protocol or store passwords.

## Reporting a vulnerability

Use **GitHub Security Advisories** (private):

https://github.com/krewdev/hubstaff-work-shell/security/advisories/new

Include `hs version`, macOS version, and reproduction steps.

## Out of scope

- Spoofing Hubstaff activity, screenshots, or UI  
- Circumventing organization policies while the timer is on  
- Vulnerabilities solely in Hubstaff’s proprietary client  

## Secrets

Never commit Hubstaff tokens from `~/Library/Application Support/Hubstaff/`.
