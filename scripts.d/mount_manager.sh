#!/data/data/com.termux/files/usr/bin/bash

# ┌─────────────────────────────────────────────┐
# │ 🔧 mount_manager.sh — Versioned, Scoped      │
# └─────────────────────────────────────────────┘

WORKFLOW="$1"
CACHE="$HOME/termux-workflow-launcher/scripts.d/mount_cache.db"
VERSION="v1.1"
STAMP="$(date '+%Y-%m-%d %H:%M:%S')"

declare -A MOUNTS=(
  [rust]="rust-share"
  [dotnet]="dotnet-share"
  [node]="node-share"
)

SHARE="$HOME/termux-workflow-launcher/${MOUNTS[$WORKFLOW]}"
MNT="/mnt/${MOUNTS[$WORKFLOW]}"
DISTRO="debian-$WORKFLOW"

echo "🛠️ Attempting to mount workflow: [$WORKFLOW]"
# 🧠 Skip if already mounted
grep -q "^$WORKFLOW|" "$CACHE" && {
  echo "🧠 [$WORKFLOW] already mounted. Skipping."
  exit 0
}

# 🧩 Mount Logic
if proot-distro list | grep -q "$DISTRO"; then
  mkdir -p "$SHARE"

  # 📝 Mount Metadata
  {
    echo "distro=$DISTRO"
    echo "workflow=$WORKFLOW"
    echo "mounted=$MNT"
    echo "timestamp=$STAMP"
    echo "manager_version=$VERSION"
  } > "$SHARE/.workflow.meta"

  echo "$WORKFLOW|$STAMP|mounted=$MNT|version=$VERSION" >> "$CACHE"

  proot-distro login "$DISTRO" --shared-tmp -- bash -c "
    mkdir -p $MNT
    mountpoint -q $MNT || mount -o bind $SHARE $MNT
    grep -qxF 'cd $MNT #mount-$WORKFLOW' ~/.bashrc || echo 'cd $MNT #mount-$WORKFLOW' >> ~/.bashrc
    grep -qxF 'cat $MNT/.workflow.meta #meta-$WORKFLOW' ~/.bashrc || echo 'cat $MNT/.workflow.meta #meta-$WORKFLOW' >> ~/.bashrc
  "
else
  echo "❌ [$DISTRO] not found. Skipping $WORKFLOW."
fi
