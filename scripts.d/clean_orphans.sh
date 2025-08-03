#!/bin/bash

# 🧼 Remove unused shares without metadata
echo "🧼 Pruning orphaned mount folders..."
for folder in $HOME/*-share; do
  [[ -d "$folder" ]] || continue
  meta="$folder/.workflow.meta"
  grep -q "$folder" "$HOME/scripts.d/mount_cache.db" || {
    echo "🧹 Removing orphan folder: $folder"
    rm -rf "$folder"
  }
done

echo "🧼 Orphan cleanup complete."