-- Bootstrap lazy.nvim
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

-- Setup lazy.nvim
require('lazy').setup({
    spec = {
        {
            'rose-pine/neovim',
            name = 'rose-pine',
            config = function()
                require('rose-pine').setup({
                    styles = {
                        bold = false,
                        italic = false
                    }
                })

                vim.cmd.colorscheme('rose-pine')
            end
        },
        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
            config = function()
                local configs = require('nvim-treesitter.configs')
                configs.setup({
                    ensure_installed = { 'cpp', 'typescript', 'python' },
                    highlight = {
                        enable = true
                    },
                })
            end
        },
        {
            'mason-org/mason-lspconfig.nvim',
            opts = {},
            dependencies = {
                { 'mason-org/mason.nvim', opts = {} },
                'neovim/nvim-lspconfig',
            },
        },
        {
            'saghen/blink.cmp',
            dependencies = { 'rafamadriz/friendly-snippets' },
            version = '1.*',
            opts = {
                keymap = {
                    preset = 'none',
                    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                    ['<C-e>'] = { 'hide', 'fallback' },
                    ['<cr>'] = { 'accept', 'fallback' },

                    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

                    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

                    ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
                },
                appearance = { nerd_font_variant = 'mono' },
                completion = {
                    documentation = { auto_show = true },
                    list = { selection = { preselect = false, auto_insert = false } }
                },
                sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
                fuzzy = { implementation = 'prefer_rust_with_warning' },
                signature = { enabled = true }
            },
            opts_extend = { 'sources.default' }
        },
        {
            'nvim-telescope/telescope.nvim', tag = '0.1.8',
            dependencies = {
                'nvim-lua/plenary.nvim',
                { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            },
            config = function()
                local telescope = require('telescope')
                local actions = require('telescope.actions')
                telescope.setup({
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

                                ['<tab>'] = actions.move_selection_next,
                                ['<s-tab>'] = actions.move_selection_previous,
                            },
                        },
                    }
                })

                telescope.load_extension('fzf')
            end
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            opts = {
                options = { section_separators = '', component_separators = '│' },
                tabline = {
                    lualine_a = {
                        {
                            'buffers',
                            symbols = { alternate_file = '' }
                        }
                    }
                },
                sections = {
                    lualine_c = {
                        {
                            'filename',
                            path = 1,
                            symbols = { modified = '' }
                        }
                    }
                },
            }
        },
        {
            'aserowy/tmux.nvim',
            opts = {}
        },
        {
            'nvim-tree/nvim-tree.lua',
            version = '*',
            lazy = false,
            dependencies = {
                'nvim-tree/nvim-web-devicons',
            },
            config = function()
                require('nvim-tree').setup {
                    actions = {
                        open_file = {
                            quit_on_open = true
                        }
                    }
                }
            end,
        },
        'tpope/vim-fugitive',
        {
            'windwp/nvim-autopairs',
            event = 'InsertEnter',
            config = true
        }
    },
    install = { colorscheme = { 'rose-pine' } }
})

vim.lsp.config('clangd', {
    cmd = { 'clangd', '--header-insertion=never' }
})
