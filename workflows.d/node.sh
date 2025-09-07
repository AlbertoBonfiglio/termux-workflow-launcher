#!/data/data/com.termux/files/usr/bin/bash

DISTRO="debian-node"
SHARE="$HOME/dev-share"
mkdir -p "$SHARE"

if ! proot-distro list | awk '{print $1}' | grep -qx "$DISTRO"; then
  echo "❌ [$DISTRO] not found."
#if ! proot-distro list --verbose 2>/dev/null | grep -q "$DISTRO"; then
  echo "📦 Installing $DISTRO..."
  proot-distro install --override-alias $DISTRO debian
  ## cp -r ~/.proot-distro/installed-rootfs/alpine ~/.proot-distro/installed-rootfs/$DISTRO

proot-distro login "$DISTRO" --shared-tmp -- bash -c '
apt update && apt install curl git build-essential bash-completion -y
mkdir HOME/.nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
cat <<EOF >> ~/.bashrc
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && . "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && . "\$NVM_DIR/bash_completion"
export PATH="\$NVM_DIR:\$PATH"
nvm use default > /dev/null 2>&1 || true
latest_node="\$(ls -1 "\$NVM_DIR/versions/node" | sort -V | tail -n1)"
EOF
'
fi
# Inject alias
alias dev-node="proot-distro login $DISTRO_NAME"

