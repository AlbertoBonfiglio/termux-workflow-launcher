#!/data/data/com.termux/files/usr/bin/bash

# ┌─────────────────────────────────────────────┐
# │ 🧠 Termux Workflow Launcher — Main Script    │
# └─────────────────────────────────────────────┘

# ✅ Validate rig
bash "$HOME/termux-workflow-launcher/scripts.d/validate_rig.sh"

# 🔗 Inject aliases
bash "$HOME/termux-workflow-launcher/scripts.d/inject_aliases.sh"

# 🛠️ Prep mount cache
touch "$HOME/termux-workflow-launcher/scripts.d/mount_cache.db"

# 🌐 Check internet
source "$HOME/termux-workflow-launcher/scripts.d/check_connectivity.sh"
check_connectivity

# ⚙️ Workflow selector
if $ONLINE; then
    source "$HOME/termux-workflow-launcher/scripts.d/check_vscode.sh"
    if check_vscode; then
        source "$HOME/termux-workflow-launcher/scripts.d/choose_workflow.sh"
        choose_workflow
        echo "🛠️ Workflow selected: $workflow"
    fi
else
    CACHE="$HOME/termux-workflow-launcher/.workflow-cache"
    [[ -f "$CACHE" ]] && workflow="$(cat "$CACHE")"
    echo "⚡ No internet. Using cached workflow: $workflow"
fi

# 🔗 Trigger workflow-specific mount manager
echo "🔗 Trigger workflow-specific mount manager"
bash "$HOME/termux-workflow-launcher/.hooks/${workflow}_mount.sh"

# 🚀 Launch distro
echo "🚀 Launching distro: debian-$workflow" 
DISTRO="debian-$workflow"
if proot-distro list | grep -q "$DISTRO"; then
    echo "🚀 Logging into $DISTRO"
    proot-distro login "$DISTRO"
else
    echo "❌ Distro not found: $DISTRO"
fi
