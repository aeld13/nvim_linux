#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
set -o pipefail

# Variables
INIT_VIM_URL="https://raw.githubusercontent.com/aeld13/nvim_linux/main/init.vim"
INIT_VIM_DIR="$HOME/.config/nvim"
PLUG_VIM_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"

# Function to detect OS
detect_os() {
    echo "Detecting operating system..."
    if [ "$(uname)" == "Darwin" ]; then
        OS="macos"
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        echo "Unsupported OS."
        exit 1
    fi
    echo "Operating system detected: $OS"
}

# Function to install packages on Ubuntu
install_packages_ubuntu() {
    echo "Updating package list and installing required packages on Ubuntu..."
    sudo apt-get update && sudo apt-get install -y \
        xclip \
        xsel \
        ripgrep \
        curl \
        wget \
        tar \
        python3.11 \
        python3.11-venv \
        tmux \
        python3-pip \
        git \
        software-properties-common
}

# Function to install packages on Debian-based systems
install_packages_debian() {
    echo "Updating package list and installing required packages on Debian-based system..."
    sudo apt-get update && sudo apt-get install -y \
        xclip \
        xsel \
        ripgrep \
        curl \
        wget \
        tar \
        python3.11 \
        python3.11-venv \
        tmux \
        python3-pip \
        git \
        software-properties-common
}

# Function to install packages on macOS
install_packages_macos() {
    echo "Installing required packages on macOS..."
    # Check if Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew update
    brew install \
        xclip \
        ripgrep \
        curl \
        wget \
        python@3.11 \
        tmux

    # Install pip if not present
    if ! command -v pip3 >/dev/null 2>&1; then
        echo "Installing pip..."
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        python3 get-pip.py
        rm get-pip.py
    fi
}

# Function to install Neovim via snap
install_neovim() {
    echo "Installing Neovim via snap..."

    # Install snapd if not already installed
    if ! command -v snap >/dev/null 2>&1; then
        echo "snapd not found. Installing snapd..."
        if [ "$OS" == "macos" ]; then
            echo "snap is not supported on macOS in this script."
            exit 1
        else
            sudo apt update
            sudo apt install -y snapd
            # Ensure snapd is running
            sudo systemctl enable --now snapd
            # Enable classic snap support
            sudo ln -s /var/lib/snapd/snap /snap
        fi
    fi

    # Install Neovim via snap
    sudo snap install nvim --classic

    # Ensure /snap/bin is in PATH
    if ! echo "$PATH" | grep -q "/snap/bin"; then
        echo "Adding /snap/bin to PATH..."
        SHELL_RC="$HOME/.bashrc"
        if [ "$SHELL" = "/bin/zsh" ]; then
            SHELL_RC="$HOME/.zshrc"
        fi
        echo "export PATH=\"\$PATH:/snap/bin\"" >> "$SHELL_RC"
        export PATH="$PATH:/snap/bin"
    fi

    # Verify that nvim is accessible
    if ! command -v nvim >/dev/null 2>&1; then
        echo "nvim command not found after installation. Creating symlink..."
        sudo ln -s /snap/bin/nvim /usr/local/bin/nvim
    fi
}

# Function to setup Neovim configuration
setup_nvim_config() {
    echo "Setting up Neovim configuration..."
    mkdir -p "$INIT_VIM_DIR"
    wget -O "$INIT_VIM_DIR/init.vim" "$INIT_VIM_URL"
}

# Function to install vim-plug
install_vim_plug() {
    echo "Installing vim-plug..."
    curl -fLo "$PLUG_VIM_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

# Function to install Python dependencies via apt
install_python_dependencies() {
    echo "Installing python3-pylsp and python3-debugpy via apt..."
    sudo apt-get install -y python3-pylsp python3-debugpy
}

# Function to install Node.js and pyright (optional)
install_node_and_pyright() {
    echo "Installing Node.js and pyright..."
    if ! command -v node >/dev/null 2>&1; then
        if [ "$OS" == "macos" ]; then
            brew install node
        else
            sudo apt-get install -y nodejs npm
        fi
    fi
    sudo npm install -g pyright
}

# Function to install tmux plugin manager (optional)
install_tmux_plugin_manager() {
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

# Function to install Neovim plugins
install_nvim_plugins() {
    echo "Installing Neovim plugins..."
    nvim +PlugInstall +qall
}

# Main Execution Flow
main() {
    detect_os

    case "$OS" in
        ubuntu)
            install_packages_ubuntu
            ;;
        debian|raspbian)
            install_packages_debian
            ;;
        macos)
            install_packages_macos
            ;;
        *)
            echo "OS '$OS' is not supported by this script."
            exit 1
            ;;
    esac

    install_neovim
    setup_nvim_config
    install_vim_plug
    install_python_dependencies
    # Uncomment the following line if pyright is needed
    # install_node_and_pyright
    install_nvim_plugins
    # Optional: Install tmux plugin manager
    # install_tmux_plugin_manager

    echo "Neovim setup completed successfully!"
    echo "Please restart your terminal or source your shell configuration file to update PATH."
}

# Run the main function
main
