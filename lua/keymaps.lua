-- exit insert mode by pressing J and K relatively fast (any order and case-insensitive)
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('i', 'jK', '<esc>')
vim.keymap.set('i', 'Jk', '<esc>')
vim.keymap.set('i', 'JK', '<esc>')

vim.keymap.set('i', 'kj', '<esc>')
vim.keymap.set('i', 'kJ', '<esc>')
vim.keymap.set('i', 'Kj', '<esc>')
vim.keymap.set('i', 'KJ', '<esc>')

-- telescope
local builtin = require('telescope.builtin')
local ivy = require('telescope.themes').get_ivy()
vim.keymap.set('n', '<leader>ff', function() builtin.find_files(ivy) end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', function() builtin.git_files(ivy) end, { desc = 'Telescope git files' })
vim.keymap.set('n', '<leader>fl', function() builtin.live_grep(ivy) end, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', function() builtin.buffers(ivy) end, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', function() builtin.help_tags(ivy) end, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fs', function() builtin.grep_string(ivy) end, { desc = 'Telescope grep string' })
vim.keymap.set('n', '<leader>fd', function() builtin.diagnostics(ivy) end, { desc = 'Telescope diagnostics' })

-- TODO: redo
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)

-- TODO: redo
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', '<c-p>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<c-n>', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>j', vim.diagnostic.open_float)

-- navigate and close buffers
local utils = require('utils')
vim.keymap.set('n', '<tab>', '<cmd>bnext<cr>')
vim.keymap.set('n', '<s-tab>', '<cmd>bprev<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>bd!<cr>')
vim.keymap.set('n', '<leader>o', utils.CloseAllButCurrentBuffer, { desc = 'Close all buffers but current' })

-- close windows
vim.keymap.set('n', '<a-o>', '<cmd>on<cr>')
vim.keymap.set('n', '<a-q>', '<cmd>q<cr>')

-- split the screen
vim.keymap.set('n', '<leader>v', '<cmd>vs<cr>')
vim.keymap.set('n', '<leader>h', '<cmd>sp<cr>')

-- move lines with Alt-h/j/k/l
local silent = { silent = true }
vim.keymap.set('n', '<a-j>', ':m .+1<cr>==', silent)
vim.keymap.set('n', '<a-k>', ':m .-2<cr>==', silent)
vim.keymap.set('i', '<a-j>', '<esc>:m .+1<cr>==gi', silent)
vim.keymap.set('i', '<a-k>', '<esc>:m .-2<cr>==gi', silent)
vim.keymap.set('v', '<a-j>', ':m \'>+1<cr>gv=gv', silent)
vim.keymap.set('v', '<a-k>', ':m \'<-2<cr>gv=gv', silent)

-- open file tree
vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

-- switch between source and header files (C/C++ only)
vim.keymap.set('n', '<leader>s', '<cmd>LspClangdSwitchSourceHeader<cr>')

-- clear highlighted search
vim.keymap.set('n', '<leader>n', '<cmd>nohl<cr>')

-- save buffer
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')

-- harpoon
local mark = require('harpoon.mark')
local ui = require('harpoon.ui')
vim.keymap.set('n', '<leader>a', mark.add_file)
vim.keymap.set('n', '<leader>m', ui.toggle_quick_menu)
vim.keymap.set('n', '<a-u>', function() ui.nav_file(1) end)
vim.keymap.set('n', '<a-i>', function() ui.nav_file(2) end)
vim.keymap.set('n', '<a-o>', function() ui.nav_file(3) end)
vim.keymap.set('n', '<a-p>', function() ui.nav_file(4) end)
