# Usage guide

## Daily workflow

1. **Start work on a task**

   ```bash
   hs projects
   hs tasks <project_id>
   hs start <task_id>
   ```

2. **Do the work** — real Hubstaff is tracking under your org’s policies.

3. **End work / no tasks left**

   ```bash
   hs stop
   ```

   This stops the timer and quits Hubstaff so background collection does not continue.

## Guard mode

If you sometimes leave Hubstaff open by accident:

```bash
hs guard-bg
```

Every `HUBSTAFF_GUARD_INTERVAL` seconds (default 30):

- App open + timer on a **task** → leave it alone  
- App open + timer on **without** a task → stop + quit  
- App open + timer **off** → quit  

Stop the watcher:

```bash
hs guard-stop
```

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `HubstaffCLI not found` | Install Hubstaff desktop app |
| `Could not connect to timer` / CLI errors | Enable **Scripted control** in Preferences; restart Hubstaff |
| `Failed to start timer app, or no user logged in` | Open Hubstaff UI, log in, then retry |
| `Timer is not tracking` on stop | Already stopped — OK |
| Status hard to parse | Run `hs status` with app open; open an issue with redacted output |

Run diagnostics:

```bash
hs doctor
```

## Keep app open after stop

```bash
HUBSTAFF_KEEP_OPEN=1 hs stop
```

Only the timer stops; screenshots should not run with timer off, but quitting (`hs stop` default) is stricter.
