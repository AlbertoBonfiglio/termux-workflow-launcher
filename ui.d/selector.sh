#!/bin/bash

workflow=$(printf "node\ndotnet" | fzf --height 40% --border --prompt="🔧 Select workflow: ")