# 🚀 Reboot to Windows

A clean, fast, and user-friendly way to reboot **directly into Windows** from Linux on UEFI dual‑boot systems.

If you are dual‑booting Linux and Windows for **gaming, work, or testing**, this tool removes the friction of rebooting, watching GRUB, and manually selecting Windows every single time.

Instead, you get a **one‑click “Reboot to Windows”** entry in your desktop menu — with a visual countdown and cancel option.

---

## ✨ Why you want this

- 🎮 Gaming on Windows, daily driving Linux  
- 🔁 Frequent OS switching  
- 🖱️ You want intention, not GRUB roulette  
- 🧠 You want something simple, transparent, and reversible  

This script does **one thing**, and it does it properly.

---

## ✨ Features

- One‑click **Reboot to Windows** from the application menu
- Uses **UEFI BootNext** (no permanent boot order changes)
- Visual **countdown dialog** with:
  - Automatic reboot after N seconds
  - **Reboot Now** button
  - **Cancel** button
- Clean separation between:
  - User‑level GUI script
  - Minimal root helper
- No GRUB modification
- No background services
- Fully removable (uninstall script included)

---

## 🧠 How it works (high‑level)

1. You click **Reboot to Windows**
2. A countdown dialog appears
3. When confirmed:
   - UEFI `BootNext` is set to Windows
   - The system reboots
4. Windows boots **once**
5. Next reboot returns to Linux automatically

Under the hood:
```bash
efibootmgr -n <Windows Boot ID>
```

This uses standard UEFI functionality and does **not** change your permanent boot order.

---

## 📦 Requirements

- UEFI‑based dual‑boot system
- Linux with:
  - `efibootmgr`
  - `zenity`
  - `sudo`
- KDE Plasma recommended (works on other desktops too)

---

## 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/<your-user>/reboot-to-windows.git
cd reboot-to-windows
```

Run the installer:

```bash
chmod +x install.sh
./install.sh
```

You will be prompted for sudo **once** to install the minimal root helper.

After installation, **Reboot to Windows** will appear in your application menu.

---

## 🧹 Uninstall

```bash
./uninstall.sh
```

Everything is removed cleanly. No leftovers.

---

## 🔧 Configuration

### Windows Boot ID

By default, the helper uses:

```bash
efibootmgr -n 0000
```

If your Windows Boot Manager uses a different ID:

```bash
sudo efibootmgr
```

Then edit:

```bash
/usr/local/sbin/reboot-to-windows-root
```

---

## 🔐 Security notes

- Root access is limited to **one single command**
- No stored passwords
- No background daemons
- No system services modified

This is intentionally small, auditable, and boring — in a good way.

---

## 🤔 Why this exists

Linux users dual‑boot with Windows for a reason.

But rebooting into Windows shouldn’t feel like:
> “Hope GRUB does the right thing.”

This tool makes OS switching **intentional, fast, and predictable**.

---

## 📜 License

MIT License

---

## 🙌 Contributions

Issues and pull requests are welcome.

If you improve:
- desktop integration
- dialogs
- portability  
feel free to contribute.
