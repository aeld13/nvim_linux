#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
set -o pipefail

# Variables
PACKAGE_DIR="neovim_offline_package"
INIT_VIM_URL="https://raw.githubusercontent.com/aeld13/nvim_linux/main/init.vim"
PLUG_VIM_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
REQUIREMENTS_FILE="requirements.txt"

# List of system packages to collect
SYSTEM_PACKAGES=(
    xclip
    xsel
    ripgrep
    curl
    wget
    tar
    python3.11
    python3.11-venv
    tmux
    python3-pip
    git
    software-properties-common
)

# List of Python packages to collect
PYTHON_PACKAGES=(
    python-lsp-server
    debugpy
)

# Neovim plugins list (from your init.vim or plugin manager)
NVIM_PLUGINS=(
    "https://github.com/junegunn/vim-plug.git"
    # Add other plugin repository URLs here
)

# Function to collect system packages
collect_system_packages() {
    echo "Collecting system packages..."
    mkdir -p "$PACKAGE_DIR/packages/deb_packages"
    cd "$PACKAGE_DIR/packages/deb_packages"

    # Use apt to download .deb files
    sudo apt-get update
    for pkg in "${SYSTEM_PACKAGES[@]}"; do
        echo "Downloading $pkg..."
        apt-get download "$pkg"
    done
    cd -
}

# Function to collect Neovim tar.gz
collect_neovim_tarball() {
    echo "Collecting Neovim tar.gz..."
    mkdir -p "$PACKAGE_DIR/neovim"
    wget -O "$PACKAGE_DIR/neovim/nvim-linux64.tar.gz" "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"
}

# Function to collect Python packages
collect_python_packages() {
    echo "Collecting Python packages..."
    mkdir -p "$PACKAGE_DIR/packages/python_packages"
    cd "$PACKAGE_DIR/packages/python_packages"

    # Create requirements.txt
    echo "${PYTHON_PACKAGES[@]}" | tr ' ' '\n' > "$REQUIREMENTS_FILE"

    # Download Python packages
    pip3 download -r "$REQUIREMENTS_FILE"

    cd -
}

# Function to collect Neovim plugins
collect_nvim_plugins() {
    echo "Collecting Neovim plugins..."
    mkdir -p "$PACKAGE_DIR/packages/nvim_plugins"

    for repo in "${NVIM_PLUGINS[@]}"; do
        echo "Cloning $repo..."
        git clone --depth 1 "$repo" "$PACKAGE_DIR/packages/nvim_plugins/$(basename "$repo" .git)"
    done
}

# Function to collect configuration files
collect_configs() {
    echo "Collecting configuration files..."
    mkdir -p "$PACKAGE_DIR/configs"

    # Download init.vim
    wget -O "$PACKAGE_DIR/configs/init.vim" "$INIT_VIM_URL"

    # Download plug.vim
    mkdir -p "$PACKAGE_DIR/configs/autoload"
    curl -fLo "$PACKAGE_DIR/configs/autoload/plug.vim" --create-dirs "$PLUG_VIM_URL"
}

# Function to package everything
package_all() {
    echo "Creating the offline package..."
    tar -czvf neovim_offline_package.tar.gz "$PACKAGE_DIR"
    echo "Offline package created: neovim_offline_package.tar.gz"
}

# Main function
main() {
    # Clean up previous package directory if exists
    if [ -d "$PACKAGE_DIR" ]; then
        rm -rf "$PACKAGE_DIR"
    fi

    mkdir -p "$PACKAGE_DIR/packages"

    collect_system_packages
    collect_python_packages
    collect_neovim_tarball
    collect_nvim_plugins
    collect_configs
    package_all

    # Clean up the package directory
    rm -rf "$PACKAGE_DIR"
}

# Run the main function
main

