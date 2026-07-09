# Contributing

Thanks for helping improve **hubstaff-work-shell**.

## Ground rules

1. **No spoofing.** Do not add features that fake Hubstaff activity, screenshots, or presence.
2. **Official client only.** Prefer Hubstaff’s own `HubstaffCLI` and documented scripted control.
3. **macOS first.** Linux/Windows PRs should use the real Hubstaff CLI for that platform when available.
4. Keep the shell **dependency-free** (bash + standard macOS tools).

## Development setup

```bash
git clone https://github.com/krewdev/hubstaff-work-shell.git
cd hubstaff-work-shell
chmod +x bin/hs install.sh
./bin/hs doctor
```

Optional:

```bash
shellcheck bin/hs
```

## Pull requests

- Describe the problem and the fix.
- Keep commits focused.
- Update `README.md` if user-facing behavior changes.
- Bump `HS_VERSION` in `bin/hs` for user-visible releases.

## Ideas that are welcome

- More reliable parsing of `HubstaffCLI status` output
- LaunchAgent example for `hs guard-bg` (documented, opt-in)
- Homebrew formula
- Better error messages when Scripted control is off
- Tests that mock CLI output without needing Hubstaff installed

## Ideas that will be rejected

- Mouse jigglers / fake input
- Fake Hubstaff UI or branding to deceive
- Bypassing org policies while the timer is intentionally running
