" Esc to get out of terminal
" F5 to return to netrw
" ctri p to paste to terminal
" space-y to copy file path 
let mapleader = "\<Space>"
tnoremap <ESC> <C-\><C-n>
nnoremap <leader><Backspace> :e %:h<CR>
nnoremap <F5>                :e %:h<CR>
nnoremap <leader>y :let @+ = expand('%:p')<CR>
cnoremap <C-p> <C-r>+


for mode in ['n', 'x', 'i']
	execute mode . "noremap <Up> " . (mode == 'i' ? "<C-o>gk" : "gk")
	execute mode . "noremap <Down> " . (mode == 'i' ? "<C-o>gj" : "gj")
endfor

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
set fileencoding=utf-8


" Function to set tmux display variable
function! RefreshDisplay()
	let l:display = system("tmux show-environment | grep '^DISPLAY'")[8:]
	let l:clean_display = substitute(l:display, '\n','', 'g')
	let $DISPLAY = l:clean_display
endfunction

command! RefreshDisplay call RefreshDisplay()


nnoremap <leader>b : Buffers <CR> 
nnoremap <leader>ff :Files %<CR>
nnoremap <leader>fF :Files /<CR>
nnoremap <leader>fs :lcd %:p:h<CR> :Rg <CR>
nnoremap <leader>fS :lcd <CR> :Rg <CR>
nnoremap <leader>q :bn <CR>:bd # <CR>
nnoremap <leader>Q :bn <CR>:bd! # <CR>
nnoremap <leader><Tab> :b! # <CR>
nnoremap gd :lua vim.lsp.buf.definition()<CR>

nnoremap <leader>' :call ToggleComment() <CR>


"function! ToggleComment()
"	let l:line = getline('.')
"	if l:line =~ '^#'
"		call setline('.', substitute(l:line, '^#', '', ''))
"	else
"		call setline('', '#' . l:line)
"	endif
"endfunction
"
"
"function! ToggleCommentLine(line)
"	return a:line =~ '^#' ? substitute(a:line, '^#', '', '') : '#' . a:line
"endfunction
"
"
"function! ToggleCommentVisual()
"	let l:start = line("'<")
"	let l:end   = line("'>")
"	let l:shouldComment = getline(l:start) !~ '^#'
"
"	for l:num in range(l:start, l:end)
"		let l:line = getline(l:num)
"		let l:new_line = ToggleCommentLine(l:line)
"		call setline(l:num, l:new_line)
"	endfor
"endfunction


augroup NetrwSettings
	autocmd!
	autocmd FileType netrw map <buffer> <Backspace> -
	autocmd FileType netrw nnoremap <buffer> <leader>Y :let @+ = expand('%')
	autocmd FileType netrw nnoremap <buffer> <leader>y :let @+ = expand ('%').'/'.expand('<cfile>')<CR>
  	autocmd FileType netrw let g:netrw_liststyle = 0
augroup END


call plug#begin('~/.local/share/nvim/plugged')
" Plug ' ~/git/nvim-dap'
" Plug '~/git/nvim-dap-ui'
" Plug '~/git/nvim-dap-virtual-text'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
call plug#end()



lua << EOF
require'lspconfig'.pylsp.setup{}
EOF



" let g:python3_host_prog = expand('~/.config/nvim/pylsp_venv/bin/python')

autocmd FileType json setlocal foldmethod=syntax
