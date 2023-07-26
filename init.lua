-- Editor settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.signcolumn = 'yes'
vim.o.colorcolumn = '80'
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.hlsearch = false
vim.o.scrolloff = 8
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.shiftround = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath
    })
end

vim.opt.rtp:prepend(lazypath)

-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = ' '

require('lazy').setup({
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {}
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function() 
            local configs = require('nvim-treesitter.configs')

            configs.setup({
                ensure_installed = { 'c', 'cpp' },
                sync_install = false,
                highlight = { enable = true }
            })
        end
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' }
    }
})

vim.cmd.colorscheme('tokyonight')

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

vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<m-q>', '<cmd>q!<cr>')
vim.keymap.set('n', '<m-o>', '<cmd>on<cr>')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Plugins config
local actions = require('telescope.actions')

require('telescope').setup{
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
                ['KJ'] = actions.close
            }
        }
    }
}
