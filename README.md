# termux-workflow-launcher

An offline-resilient, modular startup rig for developers using Termux. Launch VSCode Server, choose workflows (Node.js/.NET), and auto-provision Alpine-based environments with optional shared mounts — all powered by `fzf`.


- Purpose: modular startup & workflow orchestration
- Requirements: Termux, fzf, proot-distro
- Quick setup steps (clone, chmod, source .bashrc_additions)

## 🚀 Features
- Auto-launch on Termux start
- VSCode Server version detection & install
- Workflow picker with `fzf` UI (Node.js / .NET)
- Modular script structure for clean extension
- Offline fallback mode with cached workflow
- Alpine provisioning via `proot-distro`
- Aliases & shared folder mounts

## 🧰 Requirements
```bash
pkg update && pkg install curl git proot-distro bash fzf
```

## 🗂️ Full Repo Structure
```
termux-workflow-launcher/
├── README.md                    # Project overview & setup guide
├── .termux-workflow.sh          # Main orchestrator
├── scripts.d/                   # Logic components
│   ├── check_connectivity.sh
│   ├── check_vscode.sh
│   └── choose_workflow.sh
├── ui.d/                        # Interactive selector
│   └── selector.sh
├── workflows.d/                 # Modular workflows
│   ├── node.sh
│   └── dotnet.sh
└── .bashrc_additions            # Append to .bashrc for auto-launch + aliases
```

## Features

### ✅ Offline Support

If no internet is detected:
- Uses cached workflow
- Boots Alpine instance if available
- Otherwise exits gracefully

### 🗂️ Submount Injector


### 💡 Extras
- Add environment overlays via xr.d/
- Persist tooling via post-install bootstrap scripts
- Extend check_vscode.sh with config flag

## 📦 Installation Instruction

- Install the required packages 
```bash
pkg update && pkg install curl git proot-distro bash fzf
```

- Clone the repo and make files executable
```bash
git clone https://github.com/yourusername/termux-workflow-launcher.git
cd termux-workflow-launcher
chmod +x *.sh scripts.d/*.sh workflows.d/*.sh ui.d/*.sh
```

### ✨ Add Your Own Workflows
Drop a new *.sh into workflows.d/ and add its name to ui.d/selector.sh
Example:
```bash
workflow=$(printf "node\ndotnet\nrust" | fzf ...)
```

## 🪄 Auto-Launch on Termux Start

- Append .bashrc_additions to your ~/.bashrc:
```bash
cat .bashrc_additions >> ~/.bashrc
source ~/.bashrc
```
