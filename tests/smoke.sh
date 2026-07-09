#!/usr/bin/env bash
# Smoke tests for hs — work without Hubstaff.app installed.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HS="$ROOT/bin/hs"
fail=0

pass() { printf '  PASS  %s\n' "$*"; }
fail_() { printf '  FAIL  %s\n' "$*"; fail=1; }

echo "hubstaff-work-shell smoke tests"
[[ -x "$HS" ]] || chmod +x "$HS"

out=$("$HS" version)
echo "$out" | grep -q 'hs 0\.' && pass "version" || fail_ "version: $out"

out=$("$HS" help)
echo "$out" | grep -qi 'start' && pass "help" || fail_ "help"

out=$("$HS" status 2>&1) || true
# without app: "not running" or CLI missing message
if echo "$out" | grep -qiE 'not running|not found|HubstaffCLI'; then
  pass "status without app"
else
  fail_ "status: $out"
fi

out=$("$HS" doctor 2>&1) || true
echo "$out" | grep -qiE 'hs version|Hubstaff' && pass "doctor" || fail_ "doctor"

if "$HS" totally-bogus >/dev/null 2>&1; then
  fail_ "unknown command should fail"
else
  pass "unknown command fails"
fi

bash -n "$HS" && pass "bash -n bin/hs" || fail_ "bash -n"
bash -n "$ROOT/install.sh" && pass "bash -n install.sh" || fail_ "install.sh"

# start without task id should fail
if "$HS" start >/dev/null 2>&1; then
  fail_ "start without task should fail"
else
  pass "start requires task_id"
fi

if [[ "$fail" -ne 0 ]]; then
  echo "FAILED"
  exit 1
fi
echo "OK"
