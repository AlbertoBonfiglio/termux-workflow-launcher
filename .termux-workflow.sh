#!/data/data/com.termux/files/usr/bin/bash

# ┌─────────────────────────────────────────────┐
# │ 🧠 Termux Workflow Launcher — Main Script    │
# └─────────────────────────────────────────────┘

# ✅ Run rig validator (checks deps, folders, VSCode, distros)
bash "$HOME/scripts.d/validate_rig.sh"

# 🔗 Inject aliases from workflow scripts
bash "$HOME/scripts.d/inject_aliases.sh"

# 🌐 Check internet connectivity
source "$HOME/scripts.d/check_connectivity.sh"
check_connectivity

# ⚙️ Workflow selection logic
if $ONLINE; then
    # 💡 VSCode Server version check (only in online mode)
    source "$HOME/scripts.d/check_vscode.sh"
    check_vscode

    # 🎛️ Launch interactive fzf selector
    source "$HOME/scripts.d/choose_workflow.sh"
    choose_workflow
else
    # ⚠️ Offline fallback mode using cached workflow
    CACHE="$HOME/.workflow-cache"
    [[ -f "$CACHE" ]] && workflow="$(cat "$CACHE")"

    echo "⚡ No internet. Using cached workflow: $workflow"

    case "$workflow" in
        node)
            if proot-distro list | grep -q "alpine-node"; then
                echo "🚀 Launching alpine-node"
                proot-distro login alpine-node
            else
                echo "❌ alpine-node not found. Please connect online to provision it."
            fi
            ;;
        dotnet)
            if proot-distro list | grep -q "alpine-dotnet"; then
                echo "🚀 Launching alpine-dotnet"
                proot-distro login alpine-dotnet
            else
                echo "❌ alpine-dotnet not found. Please connect online to provision it."
            fi
            ;;
        *)
            echo "❌ No valid cached workflow found. Please connect to the internet and restart Termux."
            ;;
    esac
fi