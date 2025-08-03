#!/data/data/com.termux/files/usr/bin/bash

# ┌────────────────────────────────────────────┐
# │ 🔗 Inject Workflow Aliases into Shell       │
# └────────────────────────────────────────────┘

ALIAS_FILE="$HOME/.bash_aliases"
WORKFLOW_DIR="$HOME/termux-workflow-launcher/workflows.d"

log() { echo "[alias-injector] $1"; }

# Ensure alias file exists
touch "$ALIAS_FILE"

# Remove previous workflow aliases (optional: tag lines for easy cleanup)
sed -i '/# workflow-alias-start/,/# workflow-alias-end/d' "$ALIAS_FILE"

# Begin new alias block
echo "# workflow-alias-start" >> "$ALIAS_FILE"

# Extract alias lines from each workflow script
for wf_script in "$WORKFLOW_DIR"/*.sh; do
    grep '^alias ' "$wf_script" >> "$ALIAS_FILE"
done

# End alias block
echo "# workflow-alias-end" >> "$ALIAS_FILE"

log "✅ Aliases injected from $WORKFLOW_DIR into $ALIAS_FILE"

# Optional: source aliases immediately
source "$ALIAS_FILE"