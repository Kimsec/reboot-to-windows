#!/usr/bin/env bash
set -euo pipefail

# --- Config ---
GROUP_NAME="rebootwin"
BIN_GUI="/usr/local/bin/reboot-to-windows"
BIN_ROOT="/usr/local/sbin/reboot-to-windows-root"
DESKTOP_GLOBAL="/usr/share/applications/reboot_to_windows.desktop"
SUDOERS_D="/etc/sudoers.d/reboot-to-windows"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_GUI="$REPO_DIR/scripts/launchToWindows.sh"
SRC_ROOT="$REPO_DIR/scripts/reboot-to-windows-root"
SRC_DESKTOP="$REPO_DIR/desktop/reboot_to_windows.desktop"

need_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root: sudo $0"
    exit 1
  fi
}

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1"; exit 1; }; }

need_root

echo "[+] Checking dependencies..."
need_cmd bash
need_cmd zenity
need_cmd efibootmgr
need_cmd systemctl
need_cmd install
need_cmd groupadd
need_cmd usermod

echo "[+] Installing GUI script -> $BIN_GUI"
install -m 0755 "$SRC_GUI" "$BIN_GUI"

echo "[+] Installing root helper -> $BIN_ROOT"
install -m 0755 "$SRC_ROOT" "$BIN_ROOT"

echo "[+] Creating group '$GROUP_NAME' (if missing)"
groupadd -f "$GROUP_NAME"

# Add the "real" user who invoked sudo to the group (if available)
TARGET_USER="${SUDO_USER:-}"
if [ -n "$TARGET_USER" ] && id "$TARGET_USER" >/dev/null 2>&1; then
  echo "[+] Adding user '$TARGET_USER' to group '$GROUP_NAME'"
  usermod -aG "$GROUP_NAME" "$TARGET_USER"
  echo "    Note: You may need to log out/in for group changes to apply."
else
  echo "[!] Could not detect a non-root sudo user. Add your user manually:"
  echo "    sudo usermod -aG $GROUP_NAME <your-username>"
fi

echo "[+] Installing sudoers rule -> $SUDOERS_D"
cat > "$SUDOERS_D" <<EOF
# Allow members of group '$GROUP_NAME' to run the reboot helper without a password
%$GROUP_NAME ALL=(root) NOPASSWD: $BIN_ROOT
EOF
chmod 0440 "$SUDOERS_D"

echo "[+] Installing global desktop entry -> $DESKTOP_GLOBAL"
install -m 0644 "$SRC_DESKTOP" "$DESKTOP_GLOBAL"

# Force Exec to the universal path
sed -i "s|^Exec=.*$|Exec=$BIN_GUI|g" "$DESKTOP_GLOBAL"

echo
echo "[OK] Installed."
echo "    GUI:     $BIN_GUI"
echo "    Helper:  $BIN_ROOT"
echo "    Desktop: $DESKTOP_GLOBAL"
echo "    Group:   $GROUP_NAME"
echo
echo "Next steps:"
echo "  1) Log out/in (or reboot) so your group membership is active."
echo "  2) Search for 'Reboot to Windows' in your application launcher."
