" Esc to get out of terminal
" F5 to return to netrw
" ctri p to paste to terminal
" space-y to copy file path 
" copy to :command
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


command! RunScript :split | terminal python3 %


" Function to set tmux display variable
function! RefreshDisplay()
	let l:display = system("tmux show-environment | grep '^DISPLAY'")[8:]
	let l:clean_display = substitute(l:display, '\n','', 'g')
	let $DISPLAY = l:clean_display
endfunction

command! RefreshDisplay call RefreshDisplay()

nnoremap <leader>r :RunScript<CR>
nnoremap <leader>b : Buffers <CR> 
nnoremap <leader>ff :Files %<CR>
nnoremap <leader>fF :Files /<CR>
nnoremap <leader>fs :lcd %:p:h<CR> :Rg <CR>
nnoremap <leader>fS :lcd <CR> :Rg <CR>
nnoremap <leader>q :bn <CR>:bd # <CR>
nnoremap <leader>Q :bn <CR>:bd! # <CR>
nnoremap <leader><Tab> :b! # <CR>
nnoremap gd :lua vim.lsp.buf.definition()<CR>

" TODO: nnoremap <leader>' :call ToggleComment() <CR>




augroup NetrwSettings
	autocmd!
	autocmd FileType netrw map <buffer> <Backspace> -
	autocmd FileType netrw nnoremap <buffer> <leader>Y :let @+ = expand('%')
	autocmd FileType netrw nnoremap <buffer> <leader>y :let @+ = expand ('%').'/'.expand('<cfile>')<CR>
  	autocmd FileType netrw let g:netrw_liststyle = 0
augroup END


call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
" minimal install, end here

" python debugger, config at end
" Plug ' ~/git/nvim-dap'
" Plug '~/git/nvim-dap-ui'
" Plug '~/git/nvim-dap-virtual-text'

" LSP
Plug 'neovim/nvim-lspconfig'

" Autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'ray-x/cmp-treesitter'
call plug#end()




" CONFIGS BELOW (treesitter, lsp, nvim-cmp, debugger)

" Treesitter config
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "html", "json"},  -- or "all"
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF

" LSP config (pip install "python-lsp-server[all]")
lua << EOF
lspconfig = require("lspconfig")
lspconfig.pylsp.setup {
on_attach = custom_attach,
settings = {
    pylsp = {
    plugins = {
        -- formatter options
        -- black = { enabled = false },
        -- autopep8 = { enabled = false },
        -- yapf = { enabled = false },
        -- linter options
        -- pylint = { enabled = true, executable = "pylint" },
        -- pyflakes = { enabled = false },
        -- pycodestyle = { enabled = false },
        -- type checker
        -- pylsp_mypy = { enabled = true },
        -- auto-completion options
        -- jedi_completion = { fuzzy = true },
        -- import sorting
        -- pyls_isort = { enabled = true },
    },
    },
},
flags = {
    debounce_text_changes = 200,
},
capabilities = capabilities,
}
EOF


" for nvim-cmp autocomplete setup
" long because smart tab
lua << EOF
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require'cmp'
cmp.setup({ 
	completion = {
        autocomplete = false,
      },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          cmp.select_next_item()
        end

      elseif has_words_before() then
        cmp.complete()
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        end
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'cmdline' },
    { name = 'treesitter' },
  })
})
EOF


" lua << EOF
" local dap = require('dap')
" require("dapui").setup()
" dap.adapters.python = {
"   type = 'executable';
"   command = vim.fn.expand(vim.g.dap_python_executable);
"   args = { '-m', 'debugpy.adapter' };
" }
" dap.configurations.python = {
"   {
"     type = 'python';
"     request = 'launch';
"     name = "Launch file";
"     program = "${file}";
"     pythonPath = vim.fn.exepath('python');
"     console = 'integratedTerminal';
"   },
" }
" EOF
