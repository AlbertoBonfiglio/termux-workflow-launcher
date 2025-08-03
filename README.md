# termux-workflow-launcher

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
