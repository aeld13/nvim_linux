" Set leader key
let mapleader = "\<Space>"

" Terminal mappings
tnoremap <ESC> <C-\><C-n>

" Quick access to netrw
nnoremap <leader><Backspace> :e %:h<CR>
nnoremap <F5>                :e %:h<CR>

" Copy file path to clipboard
nnoremap <leader>y :let @+ = expand('%:p')<CR>

" Paste from clipboard in command mode
cnoremap <C-p> <C-r>+

" Better movement with wrapped lines
for mode in ['n', 'x', 'i']
    execute mode . "noremap <Up> " . (mode == 'i' ? "<C-o>gk" : "gk")
    execute mode . "noremap <Down> " . (mode == 'i' ? "<C-o>gj" : "gj")
endfor

" Basic settings
set termguicolors
set number
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
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
command! RunScript :split | terminal python3 %

nnoremap <leader>r :RunScript<CR>

" FZF mappings
nnoremap <leader>ff :Files .<CR>
nnoremap <leader>fF :Files ~<CR>
nnoremap <leader>fs :Rg<CR>
nnoremap <leader>/ :BLines<CR>

" Buffer navigation
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>q :bn<CR>:bd #<CR>
nnoremap <leader>Q :bn<CR>:bd! #<CR>
nnoremap <leader><Tab> :b#<CR>

" Go to definition
nnoremap gd :lua vim.lsp.buf.definition()<CR>

" Toggle comment
nnoremap <leader>' :CommentToggle<CR>


" Netrw settings
augroup NetrwSettings
    autocmd!
    autocmd FileType netrw map <buffer> <Backspace> -
    autocmd FileType netrw nnoremap <buffer> <leader>Y :let @+ = expand('%')<CR>
    autocmd FileType netrw nnoremap <buffer> <leader>y :let @+ = expand('%').'/'.expand('<cfile>')<CR>
    autocmd FileType netrw let g:netrw_liststyle = 0
augroup END

" Plugin management with vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" FZF for fuzzy finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Treesitter for syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" LSP configurations
Plug 'neovim/nvim-lspconfig'

" Autocompletion plugins
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'ray-x/cmp-treesitter'

" Commenting plugin
Plug 'terrortylor/nvim-comment'

" Debugger plugins
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'

call plug#end()

" Treesitter configuration
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "html", "json"},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF

" LSP configuration
lua << EOF
local lspconfig = require('lspconfig')

lspconfig.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false },
        mccabe = { enabled = false },
        pyflakes = { enabled = false },
      }
    }
  },
}
EOF

" Autocompletion configuration
lua << EOF
local cmp = require'cmp'

cmp.setup{
  snippet = {
    expand = function(args)
      -- For `luasnip` users.
      -- require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }
}

-- Update capabilities for LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.pylsp.setup{
  capabilities = capabilities,
}
EOF

" Debugger configuration
lua << EOF
local dap = require('dap')
local dap_python = require('dap-python')

-- Setup dap-python with the path to the Python interpreter
dap_python.setup('python3')

-- Key mappings for nvim-dap
vim.api.nvim_set_keymap('n', '<F5>', "<Cmd>lua require'dap'.continue()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<F10>', "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<F11>', "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<F12>', "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>b', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>B', "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true })
EOF
