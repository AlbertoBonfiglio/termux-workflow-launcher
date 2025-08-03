#!/bin/bash

check_connectivity() {
  echo "🌐 Checking internet..."
  if ping -c 1 github.com >/dev/null 2>&1; then
    echo "✅ Online"
    ONLINE=true
  else
    echo "❌ No internet"
    ONLINE=false
  fi
}