#!/bin/bash

choose_workflow() {
  source "$HOME/termux-workflow-launcher/ui.d/selector.sh"
  echo "$workflow" > "$HOME/termux-workflow-launcher/.workflow-cache"

  case "$workflow" in
    node) source "$HOME/termux-workflow-launcher/workflows.d/node.sh" ;;
    dotnet) source "$HOME/termux-workflow-launcher/workflows.d/dotnet.sh" ;;
    rust) source "$HOME/termux-workflow-launcher/workflows.d/rust.sh" ;;
    *) echo "❌ Unknown workflow." ;;
  esac
}