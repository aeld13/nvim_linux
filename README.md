# nvim_linux


# nvim_setup
install xclip and xsel on ubuntu machine
install XQuartz on mac, settings: allow connections from network clients

ssh -Y -i privatekey ubuntu@ip
(if -X doesn't work with clipboard)

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

After this step add this to ~/.bashrc:

export PATH="$PATH:/opt/nvim-linux64/bin"


wget -P .config/nvim/ https://raw.githubusercontent.com/aeld13/nvim_linux/main/init.vim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


#npm install -g pyright for pyright
pip install --upgrade pip
pip install "python-lsp-server[all]"

sudo apt-get install ripgrep

#could be useful to create an nvim-venv with everything in it, like notebook venv, and put pylsp there

nvim

:PlugStatus
:PlugInstall

# TODO: set configs for linter, formatter etc in pylsp in init.vim
