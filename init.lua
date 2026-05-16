vim.g.mapleader = ' '

vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'no'
vim.opt.scrolloff = 12
vim.opt.clipboard = 'unnamedplus'

vim.pack.add({
    -- colorschemes
    { src = 'https://github.com/ellisonleao/gruvbox.nvim' },

    -- oil.nvim
    { src = 'https://github.com/nvim-mini/mini.icons' },
    { src = 'https://github.com/stevearc/oil.nvim' },

    -- nvim-autopairs
    { src = 'https://github.com/windwp/nvim-autopairs' },

    -- lualine.nvim
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },

    -- vim-fugitive
    { src = 'https://github.com/tpope/vim-fugitive' },

    -- harpoon
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/theprimeagen/harpoon' },

    -- fzf-lua
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },

    -- lsp & mason
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },

    -- blink.cmp
    { src = 'https://github.com/saghen/blink.cmp', version = 'v1' },

    -- mini.nvim
    { src = 'https://github.com/nvim-mini/mini.move' },
    { src = 'https://github.com/nvim-mini/mini.basics' },

    -- quicker.nvim
    { src = 'https://github.com/stevearc/quicker.nvim' },
})

vim.cmd.colorscheme('gruvbox')
vim.diagnostic.config({ virtual_text = true })
vim.lsp.config('clangd', {
    cmd = { 'clangd', '--header-insertion=never' }
})

require('mini.basics').setup {
    options = {
        basic = false,
    },
    mappings = {
        windows = true,
        move_with_alt = true,
    },
}
require('mini.icons').setup()
require('mini.move').setup()
require('oil').setup()
require('quicker').setup()
require('nvim-autopairs').setup()
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
local fzf = require('fzf-lua')
fzf.setup {
    fzf_opts   = {
        ["--cycle"] = true
    },
    builtin = { -- TODO: see if there's a way to use C-d and C-u
        ["<C-j>"] = "preview-page-down",
        ["<C-k>"] = "preview-page-up"
    },
    keymap = {
        fzf = {
            ["ctrl-q"] = "select-all+accept",
        }
    },
}
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "clangd", "pyright", "ts_ls" },
}
require('blink.cmp').setup {
    signature = { enabled = true }
}

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- harpoon keymaps
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

-- fzf-lua keymaps
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

-- some lsp keymaps
vim.keymap.set('n', '<c-n>', function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<c-p>', function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', '<leader>j', vim.diagnostic.open_float, { desc = "Open diagnostic window" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set("n", "<leader>s", "<CMD>LspClangdSwitchSourceHeader<CR>", { desc = "Switch between source and header files in C & C++" })
