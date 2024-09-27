#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
set -o pipefail

# Variables
PACKAGE_DIR="neovim_offline_package"
REQUIREMENTS_FILE="requirements.txt"
INIT_VIM_DIR="$HOME/.config/nvim"
PLUG_VIM_PATH="$HOME/.local/share/nvim/site/autoload/plug.vim"

# Function to install system packages from local .deb files
install_system_packages() {
    echo "Installing system packages from local .deb files..."
    sudo dpkg -i "$PACKAGE_DIR/packages/deb_packages/"*.deb || sudo apt-get install -f -y
}

# Function to install Python packages from local files
install_python_packages() {
    echo "Installing Python packages from local files..."
    pip3 install --no-index --find-links="$PACKAGE_DIR/packages/python_packages" -r "$PACKAGE_DIR/packages/python_packages/$REQUIREMENTS_FILE"
}

# Function to install Neovim from tar.gz
install_neovim_tarball() {
    echo "Installing Neovim from tar.gz..."
    tar -xzvf "$PACKAGE_DIR/neovim/nvim-linux64.tar.gz" -C "$PACKAGE_DIR/neovim/"
    sudo cp -r "$PACKAGE_DIR/neovim/nvim-linux64/"* /usr/local/
}

# Function to set up Neovim configuration
setup_nvim_config() {
    echo "Setting up Neovim configuration..."
    mkdir -p "$INIT_VIM_DIR"
    cp "$PACKAGE_DIR/configs/init.vim" "$INIT_VIM_DIR/"

    mkdir -p "$(dirname "$PLUG_VIM_PATH")"
    cp "$PACKAGE_DIR/configs/autoload/plug.vim" "$PLUG_VIM_PATH"
}

# Function to install Neovim plugins from local copies
install_nvim_plugins() {
    echo "Installing Neovim plugins from local copies..."
    PLUGGED_DIR="$HOME/.local/share/nvim/plugged"
    mkdir -p "$PLUGGED_DIR"
    cp -r "$PACKAGE_DIR/packages/nvim_plugins/"* "$PLUGGED_DIR/"

    # Optional: Run PlugInstall to ensure everything is set up
    nvim +PlugInstall +qall
}

# Main function
main() {
    # Check if the package exists
    if [ ! -f "neovim_offline_package.tar.gz" ]; then
        echo "Offline package 'neovim_offline_package.tar.gz' not found."
        exit 1
    fi

    # Extract the package
    echo "Extracting the offline package..."
    tar -xzvf neovim_offline_package.tar.gz

    install_system_packages
    install_python_packages

    install_neovim_tarball  # Install Neovim from tarball

    setup_nvim_config
    install_nvim_plugins

    # Clean up
    rm -rf "$PACKAGE_DIR"

    echo "Neovim setup completed successfully!"
}

# Run the main function
main

