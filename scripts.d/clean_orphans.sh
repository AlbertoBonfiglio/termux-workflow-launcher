#!/bin/bash

# 🧼 Remove unused shares without metadata
echo "🧼 Pruning orphaned mount folders..."
for folder in $HOME/termux-workflow-launcher/*-share; do
  [[ -d "$folder" ]] || continue
  meta="$folder/termux-workflow-launcher/.workflow.meta"
  grep -q "$folder" "$HOME/termux-workflow-launcher/scripts.d/mount_cache.db" || {
    echo "🧹 Removing orphan folder: $folder"
    rm -rf "$folder"
  }
done

echo "🧼 Orphan cleanup complete."