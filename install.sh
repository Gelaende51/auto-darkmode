#!/bin/bash
# Installs the script to ~/.local/bin and an autostart entry to ~/.config/autostart.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="$HOME/.local/bin/auto-knight-color"
autostart="$HOME/.config/autostart/auto-knight-color.desktop"

install -Dm755 "$here/auto-knight-color" "$target"
mkdir -p "$HOME/.config/autostart"
sed "s|^Exec=.*|Exec=$target|" "$here/auto-knight-color.desktop" >"$autostart"

echo "installed $target"
echo "autostart entry: $autostart"
echo
echo "start it for this session:"
echo "  systemctl --user start 'app-auto\\x2dknight\\x2dcolor@autostart.service'"
echo "  # or simply: $target &"
