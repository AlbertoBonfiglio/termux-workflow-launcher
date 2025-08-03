#!/data/data/com.termux/files/usr/bin/bash

# ┌────────────────────────────┐
# │ 🧪 Termux Rig Validator     │
# └────────────────────────────┘

log() { echo "[workflow-validator] $1"; }

# Check for required packages
REQUIRED_PKGS=(curl git proot-distro bash fzf)
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! command -v "$pkg" >/dev/null; then
        log "Missing package: $pkg — auto-installing..."
        pkg install -y "$pkg"
    fi
done

# Create shared mount if missing
if [ ! -d "$HOME/dev-share" ]; then
    log "Creating shared folder at ~/dev-share"
    mkdir -p "$HOME/dev-share"
fi

# Verify code-server location
if [ ! -f "$HOME/.vscode-server/bin/code-server" ]; then
    log "VSCode Server missing — running install script..."
    bash "$HOME/scripts.d/check_vscode.sh"
fi

# Check named Alpine distros
DISTROS=(alpine-node alpine-dotnet)
for distro in "${DISTROS[@]}"; do
    if ! proot-distro list | grep -q "$distro"; then
        log "Provisioning missing distro: $distro"
        bash "$HOME/workflows.d/${distro##alpine-}.sh"
    fi
done

# Final ping
log "✅ Rig validated. Ready to launch!"