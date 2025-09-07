#!/bin/bash

workflow=$(printf "node\ndotnet\nrust" | fzf --height 40% --border --prompt="🔧 Select workflow: ")
