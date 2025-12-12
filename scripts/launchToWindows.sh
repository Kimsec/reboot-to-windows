#!/usr/bin/bash

COUNTDOWN=4

RESULT=$(
  (
    for i in $(/usr/bin/seq "$COUNTDOWN" -1 1); do
      PERCENT=$(( (COUNTDOWN - i) * 100 / COUNTDOWN ))
      echo "$PERCENT"
      echo "# Rebooting to Windows in $i seconds..."
      /usr/bin/sleep 1
    done

    echo "100"
    echo "# Rebooting now..."
  ) | /usr/bin/zenity --progress \
        --title="Reboot to Windows" \
        --text="Rebooting to Windows in $COUNTDOWN seconds..." \
        --percentage=0 \
        --auto-close \
        --width=400 \
        --extra-button="Reboot Now" \
        --cancel-label="Cancel" 2>/dev/null
)

ZENITY_EXIT=$?

# Reboot if countdown finished (exit 0) OR if "Reboot Now" was clicked (output "Reboot Now")
if [ "$ZENITY_EXIT" -eq 0 ] || [ "$RESULT" = "Reboot Now" ]; then
  /usr/bin/sudo -n /usr/local/sbin/reboot-to-windows-root
fi
