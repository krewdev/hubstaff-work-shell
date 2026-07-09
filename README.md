# hubstaff-work-shell

[![CI](https://github.com/krewdev/hubstaff-work-shell/actions/workflows/ci.yml/badge.svg)](https://github.com/krewdev/hubstaff-work-shell/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](#requirements)

**Task-scoped control for the real [Hubstaff](https://hubstaff.com) desktop timer on macOS.**

`hs` is a small open-source shell around Hubstaff’s official **HubstaffCLI**.  
It does **not** spoof Hubstaff, forge activity, or fake screenshots. It only starts the real app when you choose a task, and **stops the timer and quits Hubstaff** when you’re done—so the client isn’t sitting in the background collecting data with no work running.

> **Not affiliated with Hubstaff / Netsoft Holdings.**  
> You must already have a legitimate Hubstaff account, the official desktop app, and org permission to use [scripted control](https://support.hubstaff.com/what-is-scripted-control/).

---

## Why this exists

Hubstaff’s desktop client can collect screenshots, app titles, URLs, and input activity **while the timer is running**. Many people leave the app open all day.

This project makes a simple policy easy:

| Situation | Behavior |
|-----------|----------|
| You have a **task** and start it with `hs start` | Real Hubstaff tracks that task |
| You run **`hs stop`** or have **no task** | Timer off + app quit → **no collection** |
| Optional **`hs guard-bg`** | If the app is open without a task timer, auto stop + quit |

---

## Requirements

- **macOS** (uses `open`, `osascript`, `pgrep`)
- [Hubstaff desktop app](https://hubstaff.com/download) installed (default: `/Applications/Hubstaff.app`)
- Hubstaff account logged in once in the GUI
- **Scripted control** enabled in Hubstaff Preferences  
  → [What is scripted control?](https://support.hubstaff.com/what-is-scripted-control/)

Linux/Windows are not supported yet (PRs welcome if you wire the official CLI paths).

---

## Install

### Option A — clone + install script

```bash
git clone https://github.com/krewdev/hubstaff-work-shell.git
cd hubstaff-work-shell
./install.sh
```

`install.sh` copies `bin/hs` to `~/bin/hs` and ensures `~/bin` is on your `PATH` (zsh/bash).

### Option B — manual

```bash
git clone https://github.com/krewdev/hubstaff-work-shell.git
mkdir -p ~/bin
cp hubstaff-work-shell/bin/hs ~/bin/hs
chmod +x ~/bin/hs
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc   # or ~/.bashrc
source ~/.zshrc
```

### One-time Hubstaff setup

1. Open **Hubstaff** and log in.
2. **Preferences** → enable **Scripted control** / **Allow CLI Control**.
3. Ensure Hubstaff is **not** set to open at login (or remove it from **System Settings → General → Login Items**).
4. Run:

```bash
hs doctor
hs stop
```

---

## Quick start

```bash
hs status                 # is Hubstaff running / collecting?
hs orgs                   # list organizations
hs projects               # list projects
hs projects <org_id>      # filter by org
hs tasks <project_id>     # list tasks
hs start <task_id>        # start real timer on a TASK
# … do the work …
hs stop                   # stop timer + quit app (no collection)
```

Optional always-on safety net:

```bash
hs guard-bg               # background watcher
hs guard-stop             # stop the watcher
```

---

## Commands

| Command | Description |
|---------|-------------|
| `hs status` | Show tracker status, or report “not running” |
| `hs orgs` | List organizations via HubstaffCLI |
| `hs projects [org_id]` | List projects |
| `hs tasks <project_id>` | List tasks for a project |
| `hs start <task_id>` | Open app if needed and start timer on a **task** |
| `hs start-project <id>` | Start timer on a project only (prefer tasks) |
| `hs resume` | Resume last project/task |
| `hs pause` | Stop timer, leave app open |
| `hs stop` | Stop timer **and quit** Hubstaff |
| `hs open` | Open UI without starting the timer |
| `hs quit` | Quit app only |
| `hs guard` | Foreground: stop+quit if not on a task |
| `hs guard-bg` | Same policy in the background |
| `hs guard-stop` | Stop background guard |
| `hs doctor` | Diagnose app/CLI/login/scripted control |
| `hs version` | Print version |
| `hs help` | Help text |

---

## How it works

```
┌─────────────┐     HubstaffCLI      ┌──────────────────────┐
│  hs (shell) │ ───────────────────► │ Hubstaff.app (real)  │
└─────────────┘   start_task/stop    │  screenshots, apps,  │
       │                             │  URLs only while     │
       │  hs stop / guard            │  TIMER IS RUNNING    │
       └──── quit Hubstaff ─────────►└──────────────────────┘
```

- All timer control goes through **`HubstaffCLI`** shipped inside `Hubstaff.app`.
- `hs stop` calls `stop` then quits the app so a background agent isn’t left running.
- `hs guard` polls `status`; if tracking without a task (or app open with timer off), it stops and quits.

Config and logs live under:

```text
~/.config/hubstaff-work/
  state
  guard.pid
  hs.log
```

---

## Environment variables

| Variable | Default | Meaning |
|----------|---------|---------|
| `HUBSTAFF_APP` | `/Applications/Hubstaff.app` | Path to the app bundle |
| `HUBSTAFF_CLI` | `$HUBSTAFF_APP/Contents/MacOS/HubstaffCLI` | Path to CLI binary |
| `HUBSTAFF_KEEP_OPEN` | `0` | Set to `1` to leave app open after `hs stop` |
| `HUBSTAFF_GUARD_INTERVAL` | `30` | Seconds between guard checks |
| `XDG_CONFIG_HOME` | `~/.config` | Base for config directory |

---

## What this is **not**

- **Not** a fake Hubstaff client or activity generator  
- **Not** a way to hide tracking **while** a timer is running (org policies still apply)  
- **Not** an official Hubstaff product  
- **Not** a substitute for your employment/client agreement—if the org requires continuous tracking, use their rules

While a timer is **on**, Hubstaff still collects whatever the organization policy allows (screenshots, apps, etc.). This tool only helps you keep the timer **off** and the app **closed** when you have no tasks.

---

## Uninstall

```bash
rm -f ~/bin/hs
rm -rf ~/.config/hubstaff-work
# remove the PATH line from ~/.zshrc if you added it
```

Optionally remove the clone:

```bash
rm -rf /path/to/hubstaff-work-shell
```

---

## Development

```bash
git clone https://github.com/krewdev/hubstaff-work-shell.git
cd hubstaff-work-shell
make check          # shellcheck + smoke tests
./bin/hs help
./bin/hs doctor
```

| Target | What it runs |
|--------|----------------|
| `make check` | ShellCheck + smoke tests |
| `make smoke` | CLI works without Hubstaff.app |
| `make install` | Install via `install.sh` |

CI runs on every push/PR.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Bug reports and PRs for clearer status parsing, Linux support, and docs are welcome.

---

## Security

- Never commit Hubstaff tokens, session files, or `~/Library/Application Support/Hubstaff/`.
- This project does not store Hubstaff passwords; it only invokes the local CLI.
- See [SECURITY.md](SECURITY.md) for reporting issues.

---

## License

[MIT](LICENSE) — free to use, modify, and distribute.

---

## Acknowledgments

- [Hubstaff scripted control / CLI docs](https://support.hubstaff.com/what-is-scripted-control/)
- Hubstaff desktop ships `HubstaffCLI`; this project is only a workflow wrapper around it.
- **[privacy-kit](https://github.com/krewdev/privacy-kit)** — full local macOS privacy audits (`pk audit`)
