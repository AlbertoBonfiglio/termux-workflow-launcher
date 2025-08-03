#!/data/data/com.termux/files/usr/bin/bash

# ┌────────────────────────────────────────────┐
# │ ⚙️ VSCode Server Install via tur-repo       │
# └────────────────────────────────────────────┘

LOG="$HOME/.vscode-install.log"
STAMP="$(date '+%Y-%m-%d %H:%M:%S')"
BASHRC="$HOME/.bashrc"
NODE_LINE='export NODE_OPTIONS="--require /path/to/android-as-linux.js"'

echo "📦 [check_vscode] Started @ $STAMP" >> "$LOG"

# 🌐 Check internet
ping -c 1 termux.org > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "⚠️ No internet connection. Install aborted." >> "$LOG"
    echo "❌ Offline. Cannot proceed."
    exit 1
fi

# 🧃 Install tur-repo if needed
if ! pkg list-installed | grep -q tur-repo; then
    echo "📡 Installing tur-repo..." >> "$LOG"
    yes | pkg install tur-repo >> "$LOG" 2>&1
fi

# 🖥️ Install VSCode Server
if ! command -v code-server >/dev/null 2>&1; then
    echo "📡 Installing code-server from tur-repo..." >> "$LOG"
    yes | pkg install code-server >> "$LOG" 2>&1
fi

# 🧩 Ensure NODE_OPTIONS is set for code-server
BASHRC="$HOME/.bashrc"
NODE_LINE='export NODE_OPTIONS="--require $HOME/termux-workflow-launcher/.android-as-linux.js"'


# ✅ Confirm success
if command -v code-server >/dev/null 2>&1; then
    echo "✅ VSCode Server is installed and ready." >> "$LOG"
    echo "🎉 Installed successfully."

    # 🔧 Add NODE_OPTIONS if missing
    if ! grep -Fxq "$NODE_LINE" "$BASHRC"; then
        echo "$NODE_LINE" >> "$BASHRC"
        echo "✅ NODE_OPTIONS added to .bashrc" >> "$LOG"
    else
        echo "ℹ️ NODE_OPTIONS already present in .bashrc" >> "$LOG"
    fi

    exit 0
else
    echo "❌ VSCode install failed." >> "$LOG"
    echo "⚠️ Check $LOG for details."
    exit 2
fi
