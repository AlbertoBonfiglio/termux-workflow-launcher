#!/bin/bash

DISTRO="alpine-node"
SHARE="$HOME/dev-share"
mkdir -p "$SHARE"

if ! proot-distro list --verbose 2>/dev/null | grep -q "$DISTRO"; then
  echo "📦 Installing $DISTRO..."
  proot-distro install --override=alias $DISTRO alpine
  ## cp -r ~/.proot-distro/installed-rootfs/alpine ~/.proot-distro/installed-rootfs/$DISTRO

  proot-distro login $DISTRO --shared-tmp -- bash -c "
    apk update && apk upgrade && apk add curl bash
  
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  
    echo \"export NVM_DIR=\\\"\$HOME/.nvm\\\"\" >> ~/.bashrc
    echo \"[ -s \\\"\$NVM_DIR/nvm.sh\\\" ] && . \\\"\$NVM_DIR/nvm.sh\\\"\" >> ~/.bashrc
    echo \"[ -s \\\"\$NVM_DIR/bash_completion\\\" ] && . \\\"\$NVM_DIR/bash_completion\\\"\" >> ~/.bashrc
    echo \"nvm use default > /dev/null 2>&1 || true\" >> ~/.bashrc
    echo \"if [ -d \\\"\$NVM_DIR/versions/node\\\" ]; then\" >> ~/.bashrc
    echo \"  latest_node=\\\"\$(ls -1 \\\"\$NVM_DIR/versions/node\\\" | sort -V | tail -n1)\\\"\" >> ~/.bashrc
    echo \"  export PATH=\\\"\$NVM_DIR/versions/node/\\\$latest_node/bin:\\\$PATH\\\"\" >> ~/.bashrc
    echo \"fi\" >> ~/.bashrc

  # Optional debug print
    echo \"PATH set to: \\\"\$PATH\\\"\" >> ~/.bashrc
"
fi
# Inject alias
## alias dev-node="proot-distro login $DISTRO_NAME"

