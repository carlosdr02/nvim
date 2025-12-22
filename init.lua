local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.signcolumn = 'no'
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false
vim.opt.guicursor = ""

vim.diagnostic.config({
    virtual_text = true
})

vim.lsp.config('clangd', {
    cmd = { 'clangd', '--header-insertion=never' }
})

require("lazy").setup({
    spec = {
        {
            "rose-pine/neovim", name = "rose-pine",
            config = function()
                --vim.cmd.colorscheme('rose-pine')
            end
        },
        {
            "ellisonleao/gruvbox.nvim", priority = 1000,
            config = function()
                vim.cmd.colorscheme('gruvbox')
            end
        },
        {
            "rebelot/kanagawa.nvim",
            config = function()
                --vim.cmd.colorscheme('kanagawa')
            end
        },
        {
            "catppuccin/nvim", name = "catppuccin", priority = 1000,
            config = function()
                --vim.cmd.colorscheme('catppuccin')
            end
        },
        {
            "mason-org/mason-lspconfig.nvim",
            opts = {
                ensure_installed = { 'pyright', 'clangd', 'ts_ls', 'lua_ls' }
            },
            dependencies = {
                { "mason-org/mason.nvim", opts = {} },
                "neovim/nvim-lspconfig",
            },
        },
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        {
            'saghen/blink.cmp',
            dependencies = { 'rafamadriz/friendly-snippets' },
            version = '1.*',
            opts = {
                keymap = { preset = 'default' },
                appearance = {
                    nerd_font_variant = 'mono'
                },
                completion = { documentation = { auto_show = false } },
                sources = {
                    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            score_offset = 100,
                        },
                    },
                },
                fuzzy = { implementation = "prefer_rust_with_warning" }
            },
            opts_extend = { "sources.default" }
        },
        {
            "ibhagwan/fzf-lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {
                keymap = {
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    },
                }
            }
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            opts = {
                sections = {
                    lualine_c = {
                        {
                            'filename',
                            path = 1
                        }
                    }
                }
            }
        },
        {
            'stevearc/oil.nvim',
            opts = {},
            dependencies = { { "nvim-mini/mini.icons", opts = {} } },
            lazy = false,
        },
        {
            "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate",
            dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
            config = function()
                ---@diagnostic disable-next-line: missing-fields
                require('nvim-treesitter.configs').setup({
                    ensure_installed = { "c", "cpp", "typescript", "python", "lua" },
                    highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = false,
                    },
                    textobjects = {
                        select = {
                            enable = true,
                            lookahead = true,
                            keymaps = {
                                ["af"] = "@function.outer",
                                ["if"] = "@function.inner",
                                ["ac"] = "@class.outer",
                                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                                ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                            },
                            selection_modes = {
                                ['@parameter.outer'] = 'v',
                                ['@function.outer'] = 'V',
                                ['@class.outer'] = '<c-v>',
                            },
                            include_surrounding_whitespace = true,
                        },
                    },
                })
            end
        },
        {
            'theprimeagen/harpoon',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            config = true
        },
        {
            'tpope/vim-fugitive'
        },
        {
            'nvim-treesitter/nvim-treesitter-context',
            opts = {
                max_lines = 1,
                trim_scope = 'inner'
            }
        }
    },
    checker = { enabled = false },
})

local fzf = require('fzf-lua')
vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Find open buffers' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep_native, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = 'Find word under cursor' })

vim.keymap.set('n', '<leader>lr', fzf.lsp_references, { desc = 'LSP references' })
vim.keymap.set('n', '<leader>lg', fzf.lsp_definitions, { desc = 'LSP definitions' })
vim.keymap.set('n', '<leader>lG', fzf.lsp_declarations, { desc = 'LSP declarations' })
vim.keymap.set('n', '<leader>lt', fzf.lsp_typedefs, { desc = 'LSP type definitions' })
vim.keymap.set('n', '<leader>lsd', fzf.lsp_document_symbols, { desc = 'LSP symbols (document)' })
vim.keymap.set('n', '<leader>lsw', fzf.lsp_workspace_symbols, { desc = 'LSP symbols (workspace)' })
vim.keymap.set('n', '<leader>lci', fzf.lsp_incoming_calls, { desc = 'LSP calls (incoming)' })
vim.keymap.set('n', '<leader>lco', fzf.lsp_outgoing_calls, { desc = 'LSP calls (outgoing)' })
vim.keymap.set('n', '<leader>lca', fzf.lsp_code_actions, { desc = 'LSP code actions' })
vim.keymap.set('n', '<leader>ldd', fzf.lsp_document_diagnostics, { desc = 'LSP diagnostics (document)' })
vim.keymap.set('n', '<leader>ldw', fzf.lsp_workspace_diagnostics, { desc = 'LSP diagnostics (workspace)' })

vim.keymap.set('n', '<leader>gf', fzf.git_files, { desc = 'Git files' })
vim.keymap.set('n', '<leader>gb', fzf.git_branches, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gcp', fzf.git_commits, { desc = 'Git commits (project)' })
vim.keymap.set('n', '<leader>gcb', fzf.git_bcommits, { desc = 'Git commits (buffer)' })
vim.keymap.set('n', '<leader>gs', fzf.git_stash, { desc = 'Git stash' })
vim.keymap.set('n', '<leader>gw', fzf.git_worktrees, { desc = 'Git worktrees' })

vim.keymap.set('n', '<leader>mh', fzf.helptags, { desc = 'Misc help tags' })
vim.keymap.set('n', '<leader>mk', fzf.keymaps, { desc = 'Misc keymaps' })
vim.keymap.set('n', '<leader>ms', fzf.search_history, { desc = 'Misc search history' })
vim.keymap.set('n', '<leader>mo', fzf.nvim_options, { desc = 'Misc nvim options' })
vim.keymap.set('n', '<leader>mcs', fzf.colorschemes, { desc = 'Misc colorschemes' })
vim.keymap.set('n', '<leader>mcc', fzf.commands, { desc = 'Misc neovim commands' })
vim.keymap.set('n', '<leader>mch', fzf.command_history, { desc = 'Misc command history' })

vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "<leader>s", "<CMD>LspClangdSwitchSourceHeader<CR>", { desc = "Switch between source and header files in C & C++" })

vim.keymap.set('n', '<a-j>', ':m .+1<cr>==', { desc = "Move line under cursor down", silent = true })
vim.keymap.set('n', '<a-k>', ':m .-2<cr>==', { desc = "Move line under cursor up", silent = true })
vim.keymap.set('i', '<a-j>', '<esc>:m .+1<cr>==gi', { desc = "Move line under cursor down", silent = true })
vim.keymap.set('i', '<a-k>', '<esc>:m .-2<cr>==gi', { desc = "Move line under cursor up", silent = true })
vim.keymap.set('v', '<a-j>', ':m \'>+1<cr>gv=gv', { desc = "Move selected lines down", silent = true })
vim.keymap.set('v', '<a-k>', ':m \'<-2<cr>gv=gv', { desc = "Move selected lines up", silent = true })

local harpoonmark = require('harpoon.mark')
local harpoonui = require('harpoon.ui')
vim.keymap.set("n", "<leader>ha", harpoonmark.add_file, { desc = "Add file to harpoon" })
vim.keymap.set("n", "<leader>hm", harpoonui.toggle_quick_menu, { desc = "Toggle harpoon menu" })
vim.keymap.set("n", "<leader>1", function() harpoonui.nav_file(1) end, { desc = "Go to harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() harpoonui.nav_file(2) end, { desc = "Go to harpoon file 2" })
vim.keymap.set("n", "<leader3>", function() harpoonui.nav_file(3) end, { desc = "Go to harpoon file 3" })
vim.keymap.set("n", "<leader4>", function() harpoonui.nav_file(4) end, { desc = "Go to harpoon file 4" })
vim.keymap.set("n", "<leader5>", function() harpoonui.nav_file(5) end, { desc = "Go to harpoon file 5" })
vim.keymap.set("n", "<leader6>", function() harpoonui.nav_file(6) end, { desc = "Go to harpoon file 6" })
vim.keymap.set("n", "<leader7>", function() harpoonui.nav_file(7) end, { desc = "Go to harpoon file 7" })
vim.keymap.set("n", "<leader8>", function() harpoonui.nav_file(8) end, { desc = "Go to harpoon file 8" })
vim.keymap.set("n", "<leader9>", function() harpoonui.nav_file(9) end, { desc = "Go to harpoon file 9" })

vim.keymap.set('n', '<c-n>', function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<c-p>', function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', '<leader>j', vim.diagnostic.open_float, { desc = "Open diagnostic window" })

local treesittercontext = require('treesitter-context')
vim.keymap.set("n", "[c", function() treesittercontext.go_to_context(vim.v.count1) end, { desc = "Go to context" })
