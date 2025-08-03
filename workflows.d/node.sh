#!/bin/bash

DISTRO="alpine-node"
SHARE="$HOME/dev-share"
mkdir -p "$SHARE"

if ! proot-distro list | grep -q "$DISTRO"; then
  echo "📦 Installing $DISTRO..."
  proot-distro install alpine
  cp -r ~/.proot-distro/installed-rootfs/alpine ~/.proot-distro/installed-rootfs/$DISTRO

  proot-distro login $DISTRO --shared-tmp -- bash -c "
    apk update && apk add curl bash
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    echo 'export NVM_DIR=\$HOME/.nvm' >> ~/.bashrc
    echo '[ -s \$NVM_DIR/nvm.sh ] && . \$NVM_DIR/nvm.sh' >> ~/.bashrc
    mkdir -p /mnt/dev-share && mount -o bind $SHARE /mnt/dev-share
  "
fi

# Inject alias
alias dev-node="proot-distro login $DISTRO_NAME"

proot-distro login $DISTRO