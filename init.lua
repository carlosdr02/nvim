-- settings / options
vim.opt.signcolumn = 'no'
vim.opt.guicursor = ''

-- plugins
vim.pack.add({
    -- colorschemes
    { src = 'https://github.com/rebelot/kanagawa.nvim' },

    -- lsp config and mason
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },

    -- mini.nvim
    { src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable' },

    -- oil.nvim
    { src = 'https://github.com/stevearc/oil.nvim' }
})

-- colorscheme
vim.cmd.colorscheme('kanagawa')

-- mason config
require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = { 'clangd' },
}

-- mini.nvim config
require('mini.move').setup()
require('mini.pairs').setup()
require('mini.comment').setup()
require('mini.icons').setup() -- required for oil.nvim
require('mini.basics').setup {
    mappings = {
        windows = true
    }
}

-- oil.nvim config
require('oil').setup()

-- keymaps
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
