-- Settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.clipboard = 'unnamedplus'
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.scrolloff = 12
vim.o.showmode = false
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.g.mapleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'typescript', 'javascript', 'html', 'css', 'scss', 'vue', 'json' },
    callback = function()
        vim.opt.shiftwidth = 2
    end
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'cmake', 'lua' },
    callback = function()
        vim.opt.shiftwidth = 4
    end
})

-- Plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out, 'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Colorscheme
    'rebelot/kanagawa.nvim',
    'ellisonleao/gruvbox.nvim',

    -- LSP
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'l3mon4d3/luasnip',

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = 'nvim-lua/plenary.nvim'
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },

    -- Lualine
    { 'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },

    -- Bufferline
    { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },

    -- Autopairs
    { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },

    -- Nvim-tree
    {
        'nvim-tree/nvim-tree.lua', version = '*',
        lazy = false, dependencies = 'nvim-tree/nvim-web-devicons'
    },

    -- Harpoon
    { 'theprimeagen/harpoon', dependencies = 'nvim-lua/plenary.nvim' },

    -- Vim Fugitive
    'tpope/vim-fugitive',

    -- Tmux
    {
        'aserowy/tmux.nvim',
        config = function() return require('tmux').setup() end
    },

    -- Venv selector
    {
        'linux-cultist/venv-selector.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'mfussenegger/nvim-dap', 'mfussenegger/nvim-dap-python',
            { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } }
        },
        lazy = false,
        branch = 'regexp',
        config = function()
            require('venv-selector').setup()
        end,
        keys = {
            { ',v', '<cmd>VenvSelect<cr>' }
        }
    }
})

require('kanagawa').setup({
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
    statementStyle = { bold = false }
})

require('gruvbox').setup({
    bold = false,
    italic = {
        strings = false,
        emphasis = false,
        comments = false,
        folds = false
    }
})

vim.cmd.colorscheme('kanagawa')

-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

lspconfig.clangd.setup {
    capabilities = capabilities,
    cmd = { 'clangd', '--header-insertion=never' }
}

lspconfig.ts_ls.setup {
    capabilities = capabilities,
    init_options = {
        plugins = { -- I think this was my breakthrough that made it work
            {
                name = '@vue/typescript-plugin',
                location = '/usr/lib/node_modules/@vue/language-server',
                languages = { 'vue' }
            }
        }
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
}

lspconfig.volar.setup {}

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'eslint', 'html', 'cssls', 'pyright' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities = capabilities,
    }
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

require'nvim-treesitter.configs'.setup {
    ensure_installed = { 'c', 'cpp', 'javascript', 'typescript', 'vue', 'html', 'css', 'python' },
    sync_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    }
}

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup {
    extensions = {
        fzf = {}
    },
    defaults = {
        mappings = {
            i = {
                ['jk'] = actions.close,
                ['jK'] = actions.close,
                ['Jk'] = actions.close,
                ['JK'] = actions.close,

                ['kj'] = actions.close,
                ['kJ'] = actions.close,
                ['Kj'] = actions.close,
                ['KJ'] = actions.close,

                ['<tab>'] = actions.move_selection_previous,
                ['<s-tab>'] = actions.move_selection_next
            }
        }
    }
}

require('telescope').load_extension('fzf')

require('nvim-tree').setup {
    actions = {
        open_file = {
            quit_on_open = true
        }
    }
}

require('bufferline').setup({
    options = {
        offsets = {
            {
                filetype = 'NvimTree',
                text = 'File Explorer',
                text_align = 'center',
                separator = true
            }
        }
    }
})

require('lualine').setup()

-- Keymaps
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('i', 'jK', '<esc>')
vim.keymap.set('i', 'Jk', '<esc>')
vim.keymap.set('i', 'JK', '<esc>')

vim.keymap.set('i', 'kj', '<esc>')
vim.keymap.set('i', 'kJ', '<esc>')
vim.keymap.set('i', 'Kj', '<esc>')
vim.keymap.set('i', 'KJ', '<esc>')

vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')

local tmux = require('tmux')
vim.keymap.set('n', '<c-h>', tmux.move_left)
vim.keymap.set('n', '<c-j>', tmux.move_bottom)
vim.keymap.set('n', '<c-k>', tmux.move_top)
vim.keymap.set('n', '<c-l>', tmux.move_right)
vim.keymap.set('n', '<m-q>', '<cmd>q!<cr>')
vim.keymap.set('n', '<m-o>', '<cmd>on<cr>')

local silent = { silent = true }
vim.keymap.set('n', '<a-j>', ':m .+1<cr>==', silent)
vim.keymap.set('n', '<a-k>', ':m .-2<cr>==', silent)
vim.keymap.set('i', '<a-j>', '<esc>:m .+1<cr>==gi', silent)
vim.keymap.set('i', '<a-k>', '<esc>:m .-2<cr>==gi', silent)
vim.keymap.set('v', '<a-j>', ':m \'>+1<cr>gv=gv', silent)
vim.keymap.set('v', '<a-k>', ':m \'<-2<cr>gv=gv', silent)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fl', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', 'gr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>ci', builtin.lsp_incoming_calls, {})
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, {})

vim.keymap.set('n', '<c-p>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<c-n>', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>j', vim.diagnostic.open_float)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)

vim.keymap.set('n', '<tab>', '<cmd>BufferLineCycleNext<cr>')
vim.keymap.set('n', '<s-tab>', '<cmd>BufferLineCyclePrev<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>bd!<cr>')
vim.keymap.set('n', '<leader>o', '<cmd>BufferLineCloseOthers<cr>')

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<cr>')

vim.keymap.set('n', '<leader>v', '<cmd>vs<cr>')
vim.keymap.set('n', '<leader>h', '<cmd>sp<cr>')

local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<leader>a', mark.add_file)
vim.keymap.set('n', '<leader>m', ui.toggle_quick_menu)

vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end)
vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end)
vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end)
vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end)
vim.keymap.set('n', '<leader>5', function() ui.nav_file(5) end)
vim.keymap.set('n', '<leader>6', function() ui.nav_file(6) end)
vim.keymap.set('n', '<leader>7', function() ui.nav_file(7) end)
vim.keymap.set('n', '<leader>8', function() ui.nav_file(8) end)
vim.keymap.set('n', '<leader>9', function() ui.nav_file(9) end)

vim.keymap.set('n', '<leader>s', '<cmd>ClangdSwitchSourceHeader<cr>')

vim.keymap.set('n', '<leader>n', '<cmd>noh<cr>')
