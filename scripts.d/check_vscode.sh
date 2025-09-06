#!/data/data/com.termux/files/usr/bin/bash

# ┌────────────────────────────────────────────┐
# │ ⚙️ VSCode Server Install via tur-repo       │
# └────────────────────────────────────────────┘

LOG="$HOME/.vscode-install.log"
STAMP="$(date '+%Y-%m-%d %H:%M:%S')"
BASHRC="$HOME/.bashrc"
NODE_LINE='export NODE_OPTIONS="--require /path/to/android-as-linux.js"'

echo "📦 [check_vscode] Started @ $STAMP" | tee -a "$LOG"

# 🌐 Check internet
ping -c 1 termux.org > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "⚠️ No internet connection. Install aborted."  | tee -a "$LOG"
    exit 1
fi

# 🧃 Install tur-repo if needed
if ! pkg list-installed | grep -q tur-repo; then
    echo "📡 Installing tur-repo..."  | tee -a "$LOG"
    yes | pkg install tur-repo >> "$LOG" 2>&1
fi

# 🖥️ Install VSCode Server
if ! command -v code-server >/dev/null 2>&1; then
    echo "📡 Installing code-server from tur-repo..." | tee -a "$LOG"
    yes | pkg install code-server >> "$LOG" 2>&1
fi

# 🧩 Ensure NODE_OPTIONS is set for code-server
BASHRC="$HOME/.bashrc"
NODE_LINE='export NODE_OPTIONS="--require $HOME/termux-workflow-launcher/.android-as-linux.js"'


# ✅ Confirm success
if command -v code-server >/dev/null 2>&1; then
    echo "🎉 VSCode Server Installed successfully."  | tee -a "$LOG"

    # 🔧 Add NODE_OPTIONS if missing
    if ! grep -Fxq "$NODE_LINE" "$BASHRC"; then
        echo "$NODE_LINE" >> "$BASHRC"
        echo "✅ NODE_OPTIONS added to .bashrc" | tee -a "$LOG"
    else
        echo "ℹ️ NODE_OPTIONS already present in .bashrc"  | tee -a "$LOG"
    fi

    exit 0
else
    echo "❌ VSCode install failed."  | tee -a "$LOG"
    exit 2
fi
