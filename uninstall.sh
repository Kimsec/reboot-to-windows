#!/usr/bin/env bash
set -euo pipefail

GROUP_NAME="rebootwin"
BIN_GUI="/usr/local/bin/reboot-to-windows"
BIN_ROOT="/usr/local/sbin/reboot-to-windows-root"
DESKTOP_GLOBAL="/usr/share/applications/reboot_to_windows.desktop"
SUDOERS_D="/etc/sudoers.d/reboot-to-windows"

need_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root: sudo $0"
    exit 1
  fi
}

need_root

echo "[+] Removing desktop entry: $DESKTOP_GLOBAL"
rm -f "$DESKTOP_GLOBAL"

echo "[+] Removing GUI script: $BIN_GUI"
rm -f "$BIN_GUI"

echo "[+] Removing root helper: $BIN_ROOT"
rm
