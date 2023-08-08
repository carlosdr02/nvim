vim.g.mapleader = ' '

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

vim.keymap.set('n', '<a-j>', ':m .+1<cr>==')
vim.keymap.set('n', '<a-k>', ':m .-2<cr>==')
vim.keymap.set('i', '<a-j>', '<esc>:m .+1<cr>==gi')
vim.keymap.set('i', '<a-k>', '<esc>:m .-2<cr>==gi')
vim.keymap.set('v', '<a-j>', ':m \'>+1<cr>gv=gv')
vim.keymap.set('v', '<a-k>', ':m \'<-2<cr>gv=gv')

require('settings')
require('plugins')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<cr>')

vim.keymap.set('n', '<tab>', '<cmd>BufferNext<cr>')
vim.keymap.set('n', '<s-tab>', '<cmd>BufferPrevious<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>BufferClose<cr>')
vim.keymap.set('n', '<leader>o', '<cmd>BufferCloseAllButCurrent<cr>')

vim.keymap.set('n', '<leader>j', vim.diagnostic.open_float)
vim.keymap.set('n', '<c-p>', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<c-n>', vim.diagnostic.goto_next)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        -- Buffer local mappings.
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
    end
})

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

require('lspconfig').clangd.setup {
    cmd = { 'clangd', '--header-insertion=never' },
    capabilities = require('cmp_nvim_lsp').default_capabilities()
}

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local luasnip = require 'luasnip'

local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<c-u>'] = cmp.mapping.scroll_docs(-4),
        ['<c-d>'] = cmp.mapping.scroll_docs(4),
        --['<c-space>'] = cmp.mapping.complete(),
        ['<cr>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        ['<tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<s-tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' })
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' }
    }
}

vim.cmd.colorscheme('tokyonight')
