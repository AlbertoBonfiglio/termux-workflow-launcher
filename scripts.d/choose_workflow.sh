#!/bin/bash

choose_workflow() {
  source "$HOME/ui.d/selector.sh"
  echo "$workflow" > "$HOME/.workflow-cache"

  case "$workflow" in
    node) source "$HOME/workflows.d/node.sh" ;;
    dotnet) source "$HOME/workflows.d/dotnet.sh" ;;
    *) echo "❌ Unknown workflow." ;;
  esac
}