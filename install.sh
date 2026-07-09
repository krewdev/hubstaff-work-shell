#!/usr/bin/env bash
# Install hs → ~/bin and ensure PATH for common shells.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/bin/hs"
DEST_DIR="${HS_INSTALL_DIR:-$HOME/bin}"
DEST="$DEST_DIR/hs"

if [[ ! -f "$SRC" ]]; then
  echo "install: missing $SRC" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
cp "$SRC" "$DEST"
chmod +x "$DEST"
echo "Installed: $DEST"

path_line='export PATH="$HOME/bin:$PATH"'
add_path_to() {
  local rc="$1"
  [[ -f "$rc" ]] || touch "$rc"
  if grep -qF 'export PATH="$HOME/bin:$PATH"' "$rc" 2>/dev/null \
    || grep -qE '\$HOME/bin|~/bin' "$rc" 2>/dev/null; then
    echo "PATH already references bin in $rc"
  else
    printf '\n# hubstaff-work-shell\n%s\n' "$path_line" >>"$rc"
    echo "Added ~/bin to PATH in $rc"
  fi
}

# Prefer the user’s login shell rc
case "${SHELL:-}" in
  */zsh) add_path_to "$HOME/.zshrc" ;;
  */bash)
    if [[ -f "$HOME/.bashrc" ]]; then
      add_path_to "$HOME/.bashrc"
    else
      add_path_to "$HOME/.bash_profile"
    fi
    ;;
  *)
    [[ -f "$HOME/.zshrc" ]] && add_path_to "$HOME/.zshrc"
    [[ -f "$HOME/.bashrc" ]] && add_path_to "$HOME/.bashrc"
    ;;
esac

echo
echo "Next:"
echo "  source ~/.zshrc   # or open a new terminal"
echo "  hs doctor"
echo "  # Enable Hubstaff → Preferences → Scripted control"
echo "  hs stop"
echo
"$DEST" version 2>/dev/null || true
