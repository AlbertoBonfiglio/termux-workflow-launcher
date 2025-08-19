#!/data/data/com.termux/files/usr/bin/bash

# ┌────────────────────────────────────────┐
# │ 🛠️ Setup: alpine-rust via proot-distro │
# └────────────────────────────────────────┘

DISTRO="debian-rust"
SHARE="$HOME/dev-share"
mkdir -p "$SHARE"

if ! proot-distro list | grep -q "$DISTRO"; then
  echo "📦 Installing $DISTRO..."
  proot-distro install --override-alias $DISTRO debian 
  cp -r ~/.proot-distro/installed-rootfs/debian ~/.proot-distro/installed-rootfs/$DISTRO

  proot-distro login $DISTRO --shared-tmp -- bash -c "
    apk update && apk add curl bash build-base
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
    echo 'source \$HOME/.cargo/env' >> ~/.bashrc
    mkdir -p /mnt/dev-share && mount -o bind $SHARE /mnt/dev-share
  "
fi

# Inject alias
alias dev-rust="proot-distro login $DISTRO"

proot-distro login $DISTRO

