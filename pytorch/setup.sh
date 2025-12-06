#!/bin/bash

set -xeuo pipefail

export DEBIAN_FRONTEND=noninteractive
export USERNAME=user
export USER_UID=1000

sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends curl wget git sudo neovim tmux less ssh ncdu tree
rm -rf /var/lib/apt/lists/*

userdel -rf ubuntu || true
useradd -m ${USERNAME} --uid=${USER_UID}
usermod -aG sudo ${USERNAME}
echo 'user:password' | chpasswd
echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/${USERNAME}
chsh -s /bin/bash ${USERNAME}
chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}
chown -R ${USERNAME}:${USERNAME} /opt/conda
