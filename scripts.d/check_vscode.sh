#!/bin/bash

WORKDIR="$HOME/.vscode-server"
VSCODE_BINARY="$WORKDIR/bin/code-server"
LATEST_URL="https://api.github.com/repos/coder/code-server/releases/latest"

check_vscode() {
  echo "🔍 Checking VSCode..."
  if [[ ! -f "$VSCODE_BINARY" ]]; then
    echo "❌ Not installed. Install? (y/n)"
    read -r i && [[ "$i" == "y" ]] && install_vscode
  else
    CV=$("$VSCODE_BINARY" --version | head -n1)
    LV=$(curl -s "$LATEST_URL" | grep tag_name | cut -d '"' -f4)
    [[ "$CV" != "$LV" ]] && echo "🛠️ Update from $CV → $LV? (y/n)" && read -r u && [[ "$u" == "y" ]] && install_vscode
  fi
}

install_vscode() {
  mkdir -p "$WORKDIR"
  curl -L "$(curl -s "$LATEST_URL" | grep browser_download_url | grep 'linux-arm64' | cut -d '"' -f4)" -o "$WORKDIR/code-server.tar.gz"
  tar -xzf "$WORKDIR/code-server.tar.gz" -C "$WORKDIR" --strip-components=1
  echo "✅ Installed."
}