# nvim_linux

## Requirements

- **Linux**: Ubuntu, Debian, Raspberry Pi OS, or similar.
- **Windows**: no
- **Python**: Python 3.11 and `pip` for managing Python dependencies.
- **tmux** (optional): If you plan to run Neovim inside `tmux`.

## Installation

run the install.sh
:PlugInstall after it's done, source your bash. 

pylsp and debugger gets installed via pip, nvim needs to be run from the global_env with them installed.

Before running nvim: export PYTHONPATH=$PYTHONPATH:~/venv/global_env/lib/python3.11/site-packages

### Add this to the end of your ~/.bashrc:


`alias nvim="source ~/venv/global_env/bin/activate && export PYTHONPATH=\$PYTHONPATH:~/venv/global_env/lib/python3.11/site-packages && nvim"`

Then source it:

`source ~/.bashrc`
