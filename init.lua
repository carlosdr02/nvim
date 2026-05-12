-- settings / options
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

-- window navigation
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

-- move lines of code
vim.keymap.set('n', '<a-j>', ':m .+1<cr>==', { desc = "Move line under cursor down", silent = true })
vim.keymap.set('n', '<a-k>', ':m .-2<cr>==', { desc = "Move line under cursor up", silent = true })
vim.keymap.set('i', '<a-j>', '<esc>:m .+1<cr>==gi', { desc = "Move line under cursor down", silent = true })
vim.keymap.set('i', '<a-k>', '<esc>:m .-2<cr>==gi', { desc = "Move line under cursor up", silent = true })
vim.keymap.set('v', '<a-j>', ':m \'>+1<cr>gv=gv', { desc = "Move selected lines down", silent = true })
vim.keymap.set('v', '<a-k>', ':m \'<-2<cr>gv=gv', { desc = "Move selected lines up", silent = true })
