" Esc to get out of terminal
" F5 to return to netrw
" ctri p to paste to terminal
" space-y to copy file path 
" copy to :command
let mapleader = "\<Space>"
tnoremap <ESC> <C-\><C-n>
nnoremap <leader><Backspace> :e %:h<CR>
nnoremap <leader>y :let @+ = expand('%:p')<CR>
cnoremap <C-p> <C-r>+


set termguicolors 
set number 
set smartindent 
set tabstop=4
set shiftwidth=4
set ignorecase 
set smartcase 
set wildmenu 
set mouse=a
set clipboard+=unnamedplus 

" fzf keymaps
nnoremap <leader>b : Buffers <CR> 
nnoremap <leader>ff :Files %<CR>
nnoremap <leader>fF :Files /<CR>
nnoremap <leader>fs :lcd %:p:h<CR> :Rg <CR>
nnoremap <leader>fS :lcd <CR> :Rg <CR>
nnoremap <leader>/ :BLines<CR>

" shortcuts
nnoremap <leader>q :bn <CR>:bd # <CR>
nnoremap <leader>Q :bn <CR>:bd! # <CR>
nnoremap <leader><Tab> :b! # <CR>


call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
call plug#end()
