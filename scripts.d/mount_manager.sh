#!/bin/bash

# ┌────────────────────────────────────────────────────┐
# │ 🛠️ Enhanced mount_manager.sh — Metadata + Cleanup  │
# └────────────────────────────────────────────────────┘

declare -A WORKFLOWS=(
  [rust]="rust-share"
  [dotnet]="dotnet-share"
  [node]="node-share"
)

STAMP="$(date '+%Y-%m-%d %H:%M:%S')"
VERSION="v1.0"
PROOT_DISTRO_DIR="$HOME/.proot-distro/installed-rootfs"

for lang in "${!WORKFLOWS[@]}"; do
  SHARE="$HOME/${WORKFLOWS[$lang]}"
  MNT="/mnt/${WORKFLOWS[$lang]}"
  DISTRO="alpine-$lang"
  META="$SHARE/.workflow.meta"

  mkdir -p "$SHARE"

  if proot-distro list | grep -q "$DISTRO"; then
    echo "🔗 Mounting $SHARE to $DISTRO..."

    # Inject mount and workflow metadata
    echo "distro=$DISTRO"        > "$META"
    echo "workflow=$lang"       >> "$META"
    echo "mounted=$MNT"         >> "$META"
    echo "timestamp=$STAMP"     >> "$META"
    echo "manager_version=$VERSION" >> "$META"

    # Mount and inject shell enhancements
    proot-distro login $DISTRO --shared-tmp -- bash -c "
      mkdir -p $MNT
      mount -o bind $SHARE $MNT
      grep -qxF 'cd $MNT' ~/.bashrc || echo 'cd $MNT' >> ~/.bashrc
      grep -qxF 'cat $MNT/.workflow.meta' ~/.bashrc || echo 'cat $MNT/.workflow.meta' >> ~/.bashrc
    "
  else
    echo "⚠️ Distro $DISTRO not found. Skipping $lang..."
  fi
done

# 🧹 Cleanup stale metadata
echo "🧼 Checking for orphaned shares..."
for folder in $HOME/*-share; do
  [[ -d "$folder" ]] || continue
  meta="$folder/.workflow.meta"
  if [[ ! -f "$meta" ]]; then
    echo "🧹 Cleaning unknown mount: $folder"
    rm -rf "$folder"
  fi
done