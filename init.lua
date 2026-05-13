-- SETTINGS / OPTIONS
vim.opt.signcolumn = 'no'
vim.opt.guicursor = ''
vim.opt.relativenumber = true
vim.opt.scrolloff = 12
vim.opt.clipboard = 'unnamedplus'




-- PLUGINS
vim.pack.add({
    -- deps
    { src = 'https://github.com/rafamadriz/friendly-snippets' }, -- required by blink.cmp
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- required by fzf-lua and lualine
    { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- required by harpoon

    -- colorschemes
    { src = 'https://github.com/rebelot/kanagawa.nvim' },
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

    -- lsp config and mason
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },

    -- mini.nvim
    { src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable' },

    -- oil.nvim
    { src = 'https://github.com/stevearc/oil.nvim' },

    -- blink.cmp
    { src = 'https://github.com/saghen/blink.cmp', version = 'v1' },

    -- fzf-lua
    { src = 'https://github.com/ibhagwan/fzf-lua' },

    -- lualine
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },

    -- fugitive
    { src = 'https://github.com/tpope/vim-fugitive' },

    -- harpoon
    { src = 'https://github.com/theprimeagen/harpoon' },

    -- nvim-autopairs. mini.pairs doesn't quite cut it
    { src = 'https://github.com/windwp/nvim-autopairs' }
})





-- PLUGINS CONFIG

-- mason config
require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = { 'clangd', 'ts_ls', 'pyright' },
}

-- mini.nvim config
require('mini.move').setup()
require('mini.comment').setup()
require('mini.icons').setup() -- required for oil.nvim
require('mini.basics').setup {
    mappings = {
        windows = true
    }
}

-- fzf-lua config
local fzf = require('fzf-lua')
fzf.setup {
    fzf_opts   = {
        ["--cycle"] = true
    },
    builtin = { -- TODO: see if there's a way to use C-d and C-u
        ["<C-j>"] = "preview-page-down",
        ["<C-k>"] = "preview-page-up"
    },
}

-- lualine config
require('lualine').setup {
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1
            }
        }
    }
}

-- blink.cmp config
require('blink.cmp').setup {
    signature = { enabled = true }
}

-- others
require('oil').setup()
require("rose-pine").setup()
require("nvim-autopairs").setup()




-- COLORSCHEME
vim.cmd.colorscheme('catppuccin')

vim.diagnostic.config({ virtual_text = true })





-- KEYMAPS

-- oil.nvim
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- fzf-lua
vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Find open buffers' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep_native, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = 'Find word under cursor' })

vim.keymap.set('n', '<leader>lr', fzf.lsp_references, { desc = 'LSP references' })
vim.keymap.set('n', '<leader>lg', fzf.lsp_definitions, { desc = 'LSP definitions' })
vim.keymap.set('n', '<leader>lG', fzf.lsp_declarations, { desc = 'LSP declarations' })
vim.keymap.set('n', '<leader>lt', fzf.lsp_typedefs, { desc = 'LSP type definitions' })
vim.keymap.set('n', '<leader>li', fzf.lsp_implementations, { desc = 'LSP implementations' })
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

-- harpoon
local hmark = require('harpoon.mark')
local hui = require('harpoon.ui')
vim.keymap.set("n", "<leader>ha", hmark.add_file, { desc = "Add file to harpoon" })
vim.keymap.set("n", "<leader>hm", hui.toggle_quick_menu, { desc = "Toggle harpoon menu" })
vim.keymap.set("n", "<leader>1", function() hui.nav_file(1) end, { desc = "Go to harpoon file 1" })
vim.keymap.set("n", "<leader>2", function() hui.nav_file(2) end, { desc = "Go to harpoon file 2" })
vim.keymap.set("n", "<leader>3", function() hui.nav_file(3) end, { desc = "Go to harpoon file 3" })
vim.keymap.set("n", "<leader>4", function() hui.nav_file(4) end, { desc = "Go to harpoon file 4" })
vim.keymap.set("n", "<leader>5", function() hui.nav_file(5) end, { desc = "Go to harpoon file 5" })
vim.keymap.set("n", "<leader>6", function() hui.nav_file(6) end, { desc = "Go to harpoon file 6" })
vim.keymap.set("n", "<leader>7", function() hui.nav_file(7) end, { desc = "Go to harpoon file 7" })
vim.keymap.set("n", "<leader>8", function() hui.nav_file(8) end, { desc = "Go to harpoon file 8" })
vim.keymap.set("n", "<leader>9", function() hui.nav_file(9) end, { desc = "Go to harpoon file 9" })
vim.keymap.set("n", "<leader>0", function() hui.nav_file(10) end, { desc = "Go to harpoon file 10" })

-- some LSP ones
vim.keymap.set('n', '<c-n>', function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<c-p>', function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', '<leader>j', vim.diagnostic.open_float, { desc = "Open diagnostic window" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename symbol" })
