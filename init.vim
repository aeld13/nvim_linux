" Set leader key
let mapleader = "\<Space>"


" Terminal mappings
tnoremap <ESC> <C-\><C-n>

" Quick access to netrw
nnoremap <leader><Backspace> :e %:h<CR>
nnoremap <F5>                :e %:h<CR>

" Copy file path to clipboard
nnoremap <leader>y :let @+ = expand('%:p')<CR>

" Paste from clipboard to terminal mode
tnoremap <C-p> <C-\><C-N>"*Pi

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
nnoremap <leader>ff :Files %<CR>
nnoremap <leader>fF :Files ~<CR>
nnoremap <leader>fs :lcd % <CR> :Rg<CR>
nnoremap <leader>fs :lcd ~ <CR> :Rg<CR>
nnoremap <leader>/ :BLines<CR>

" Buffer navigation
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>q :bn<CR>:bd #<CR>
nnoremap <leader>Q :bn<CR>:bd! #<CR>
nnoremap <leader><Tab> :b#<CR>

" Go to definition
nnoremap gd :lua vim.lsp.buf.definition()<CR>
nnoremap K :lua vim.lsp.buf.hover()<CR>


" Toggle comment
nnoremap <leader>\' gcc
vnoremap <leader>\' gc

" Netrw settings
augroup NetrwSettings
    autocmd!
    autocmd FileType netrw map <buffer> <Backspace> -
    autocmd FileType netrw nnoremap <buffer> <leader>Y :let @+ = expand('%')<CR>
    autocmd FileType netrw nnoremap <buffer> <leader>y :let @+ = expand('%').'/'.expand('<cfile>')<CR>
    autocmd FileType netrw let g:netrw_liststyle = 0
augroup END





" DAP key mappings using leader
nnoremap <leader>db :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <leader>dB :lua require'dap'.set_breakpoint(vim.fn.input('breakpoint condition: '))<CR>
nnoremap <leader>d<Right> :lua require'dap'.continue()<CR>
nnoremap <leader>d<Up> :lua require'dap'.step_over()<CR>
nnoremap <leader>d<Down> :lua require'dap'.step_into()<CR>
nnoremap <leader>d<Left> :lua require'dap'.step_out()<CR>
nnoremap <leader>do :lua require'dapui'.open()<CR>
"nnoremap <leader>do :lua require'dap'.repl.open()<CR>

nnoremap <leader>dO :lua require'dapui'.close()<CR>
nnoremap <leader>Do :lua require'dap'.disconnect(); require'dap'.close()<CR>
"nnoremap <leader>dn :lua require'dap'.goto_next()<CR>
"nnoremap <leader>dN :lua require'dap'.goto_prev()<CR>
nnoremap <leader>dl :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <leader>dr :lua require'dap'.restart()<CR>
"vim.fn.nvim_set_keymap('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })
nnoremap <leader>de :lua require('dap').eval()<CR>








" Plugin management with vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'lambdalisue/vim-suda'

" REPL plugins, iron is best?
"Plug 'bfredl/nvim-ipy'
"Plug 'pappasam/nvim-repl'
Plug 'Vigemus/iron.nvim'

" venv plugin
Plug 'AckslD/swenv.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'stevearc/dressing.nvim'


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


" AI completion, req plenary and nvim-cmp
Plug 'milanglacier/minuet-ai.nvim'
" Commenting plugin, built into neovim 10
" Plug 'terrortylor/nvim-comment'

" Debugger plugins
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
call plug#end()


" Commenting
"lua << EOF
"#require('nvim_comment').setup()
"#EOF


" Treesitter configuration
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "html", "json", "rust"},
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF

" LSP configuration
lua << EOF
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local jedi_environment = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV .. '/bin/python' or '/usr/bin/python'

print("jedi.environment: " .. (jedi_environment or "nil"))


lspconfig.pylsp.setup{
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        jedi = {
          environment = jedi_environment,
        },
        -- formatter options
        black = { enabled = false },
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        -- linter options
        pylint = { enabled = false, executable = "pylint" },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        -- type checker
        pylsp_mypy = { enabled = false },
        -- auto-completion options
        jedi_completion = { fuzzy = false },
        -- import sorting
        pyls_isort = { enabled = false },

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
    ["<leader>h"] = require('minuet').make_cmp_map(),
  },
  sources = {
    { name = 'minuet' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
  -- performance = {
  --   -- It is recommended to increase the timeout duration due to
  --   -- the typically slower response speed of LLMs compared to
  --   -- other completion sources. This is not needed when you only
  --   -- need manual completion.
  --       fetching_timeout = 2000,
  --   },
}

EOF


" Debugger configuration
lua << EOF
local dap = require('dap')
local dap_python = require('dap-python')
require("dapui").setup()

-- Setup dap-python with the path to the Python interpreter
dap_python.setup('python3')

EOF

" Load iron.nvim and set some default configurations
lua << EOF
local iron = require("iron.core")

iron.setup {
  config = {
    -- Whether a repl should be discarded or not
    scratch_repl = true,
    -- Your repl definitions come here
    repl_definition = {
      sh = {
        -- Can be a table or a function that
        -- returns a table (see below)
        command = {"zsh"}
      },
      python = {
        command = { "ipython", "--no-autoindent" },
        format = require("iron.fts.common").bracketed_paste_python
      }
    },
    -- How the repl window will be displayed
    -- See below for more information
    repl_open_cmd = require('iron.view').split.vertical.botright(50), --bottom(40),
    -- local view = require("iron.view")
    -- repl_open_cmd = view.split.vertical.botright(50),
  },
  -- Iron doesn't set keymaps by default anymore.
  -- You can set them here or manually add keymaps to the functions in iron.core
  keymaps = {
    send_motion = "<space>sc",
    visual_send = "<space>sc",
    send_file = "<space>sf",
    send_line = "<space>sl",
    send_paragraph = "<space>sp",
    send_until_cursor = "<space>su",
    send_mark = "<space>sm",
    mark_motion = "<space>mc",
    mark_visual = "<space>mc",
    remove_mark = "<space>md",
    cr = "<space>s<cr>",
    interrupt = "<space>s<space>",
    exit = "<space>sq",
    clear = "<space>cl",
  },
  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
}

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
EOF



" venv handling config
lua << EOF
-- Set up swenv.nvim
require('swenv').setup({
  get_venvs = function(venvs_path)
    return require('swenv.api').get_venvs(venvs_path)
  end,
  venvs_path = vim.fn.expand('~/venv'),

  post_set_venv = function(env)
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    lspconfig.pylsp.setup{
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            jedi = {
              environment = env.path, -- .. '/bin/python',  -- Set jedi to use the virtual environment's interpreter
            -- extra_paths = { env.path .. '/lib/python3.10/site-packages' },  -- Adjust Python version as needed
            },
            pycodestyle = { enabled = false },
            mccabe = { enabled = false },
            pyflakes = { enabled = false },
          }
        }
      },
    }

    -- Restart pylsp with the new configuration
    vim.cmd("LspStop pylsp")
    vim.cmd("LspStart pylsp")
  end,
})

-- Optional: Keybinding to switch virtual environments
vim.api.nvim_set_keymap('n', '<leader>sw', ":lua require('swenv.api').pick_venv()<CR>", { noremap = true, silent = true })
EOF




" minuet configs
lua << EOF

require('minuet').setup{

    default_config = {
    -- Enable or disable auto-completion. Note that you still need to add
    -- Minuet to your cmp sources. This option controls whether cmp will
    -- attempt to invoke minuet when minuet is included in cmp sources. This
    -- setting has no effect on manual completion; Minuet will always be
    -- enabled when invoked manually.
    enabled = true,
    provider = 'openai_compatible',
    provider_options = {
    openai_compatible = {
        model = 'lmstudio-community/Meta-Llama-3.1-8B-Instruct-GGUF',
        system = default_system,
        few_shots = default_few_shots,
        end_point = 'http://localhost:1234/v1/chat/completions',
        api_key = 'lm_studio',
        name = 'llama_8b',
        stream = true,
        optional = {
            stop = nil,
            max_tokens = nil,
        },
    }
},
    -- the maximum total characters of the context before and after the cursor
    -- 12,800 characters typically equate to approximately 4,000 tokens for
    -- LLMs.
    context_window = 12800,
    -- when the total characters exceed the context window, the ratio of
    -- context before cursor and after cursor, the larger the ratio the more
    -- context before cursor will be used. This option should be between 0 and
    -- 1, context_ratio = 0.75 means the ratio will be 3:1.
    context_ratio = 0.75,
    throttle = 1000, -- only send the request every x milliseconds, use 0 to disable throttle.
    -- debounce the request in x milliseconds, set to 0 to disable debounce
    debounce = 400,
    -- show notification when request is sent or request fails. options:
    -- false to disable notification. Note that you should use false, not "false".
    -- "verbose" for all notifications.
    -- "warn" for warnings and above.
    -- "error" just errors.
    notify = 'verbose',
    -- The request timeout, measured in seconds. When streaming is enabled
    -- (stream = true), setting a shorter request_timeout allows for faster
    -- retrieval of completion items, albeit potentially incomplete.
    -- Conversely, with streaming disabled (stream = false), a timeout
    -- occurring before the LLM returns results will yield no completion items.
    request_timeout = 3,
    -- if completion item has multiple lines, create another completion item only containing its first line.
    add_single_line_entry = true,
    -- The number of completion items (encoded as part of the prompt for the
    -- chat LLM) requested from the language model. It's important to note that
    -- when 'add_single_line_entry' is set to true, the actual number of
    -- returned items may exceed this value. Additionally, the LLM cannot
    -- guarantee the exact number of completion items specified, as this
    -- parameter serves only as a prompt guideline.
    n_completions = 3,
    -- Defines the length of non-whitespace context after the cursor used to
    -- filter completion text. Set to 0 to disable filtering.
    --
    -- Example: With after_cursor_filter_length = 3 and context:
    --
    -- "def fib(n):\n|\n\nfib(5)" (where | represents cursor position),
    --
    -- if the completion text contains "fib", then "fib" and subsequent text
    -- will be removed. This setting filters repeated text generated by the
    -- LLM. A large value (e.g., 15) is recommended to avoid false positives.
    after_cursor_filter_length = 15,
    -- proxy port to use
    proxy = nil,
    provider_options = {
        -- see the documentation in each provider in the following part.
    },
    -- see the documentation in the `System Prompt` section
    default_template = {
        template = '...',
        prompt = '...',
        guidelines = '...',
        n_completion_template = '...',
    },
    default_few_shots = { '...' },
}
}
EOF
