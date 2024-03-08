#!/bin/bash

# Install xclip and xsel on Ubuntu
sudo apt-get update
sudo apt-get install -y xclip xsel

# Install XQuartz on Mac (if needed)
# Settings: Allow connections from network clients

# SSH into the remote machine with X11 forwarding enabled
# ssh -Y -i privatekey ubuntu@ip

# If -X doesn't work with clipboard, you may need to add ForwardX11Trusted yes to your ~/.ssh/config

# Download and install Neovim on Linux
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# Add Neovim to the PATH
echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc

# Download init.vim configuration file
mkdir -p ~/.config/nvim
wget -P ~/.config/nvim/ https://raw.githubusercontent.com/aeld13/aeld13/main/init.vim

# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install pyright (optional)
# npm install -g pyright

# Upgrade pip and install python-lsp-server
pip install --upgrade pip
pip install "python-lsp-server[all]"

# Install ripgrep
sudo apt-get install -y ripgrep

# Run Neovim and install plugins
nvim +PlugInstall +qall

# Set configurations for pylsp in init.vim (TODO)
