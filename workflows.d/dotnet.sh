#!/bin/bash

DISTRO="alpine-dotnet"
SHARE="$HOME/dev-share"
mkdir -p "$SHARE"

if ! proot-distro list | grep -q "$DISTRO"; then
  echo "📦 Installing $DISTRO..."
  proot-distro install alpine
  cp -r ~/.proot-distro/installed-rootfs/alpine ~/.proot-distro/installed-rootfs/$DISTRO

  proot-distro login $DISTRO --shared-tmp -- bash -c "
    apk update && apk add curl bash icu-libs
    curl -sSL https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh | bash
    echo 'export DOTNET_ROOT=\$HOME/.dotnet' >> ~/.bashrc
    echo 'export PATH=\$DOTNET_ROOT:\$PATH' >> ~/.bashrc
    mkdir -p /mnt/dev-share && mount -o bind $SHARE /mnt/dev-share
  "
fi

# Inject alias
alias dev-node="proot-distro login $DISTRO_NAME"

proot-distro login $DISTRO