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
echo "✅ Packages validated"

# Create shared mount if missing
if [ ! -d "$HOME/dev-share" ]; then
    log "Creating shared folder at ~/dev-share"
    mkdir -p "$HOME/dev-share"
fi
echo "✅ Shared mount validated."

# Verify code-server location
VS_HOME="/data/data/com.termux/files/usr/bin/code-server"
if [ ! -f "$VS_HOME" ]; then
    log "VSCode Server missing — running install script..."
    bash "$HOME/termux-workflow-launcher/scripts.d/check_vscode.sh"
    while [ ! -f "$VS_HOME" ]; do
        echo "⏳ Waiting for VSCode Server to install..."
        sleep 1
    done
fi
echo "✅ VS Code Server validated."

# Check named Alpine distros
DISTROS=(alpine-node alpine-dotnet alpine-rust)
for distro in "${DISTROS[@]}"; do
    echo "Validating distro: ed. $distro"
    #### if ! proot-distro list --verbose | grep -q "$distro"; then
    if ! proot-distro list --verbose 2>/dev/null | grep -q "$distro"; then
        echo -n "Do you want to provision $distro? [y/n]"
        read answer
        case "$answer" in
            [Yy])
                 log "⏳ Provisioning missing distro: $distro"
                 bash "$HOME/termux-workflow-launcher/workflows.d/${distro##alpine-}.sh"
                 ;;
        *) ;;
        esac
    else
        echo "✅ $distro validated"
    fi
done
echo "✅ Distros validated."

# Final ping
log "✅ Rig validated. Ready to launch!"
