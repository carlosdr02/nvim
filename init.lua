-- Bootstrap lazy.nvim
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.signcolumn = 'no'
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "rose-pine/neovim", name = "rose-pine",
            config = function()
                vim.cmd.colorscheme('rose-pine')
            end
        },
        {
            "mason-org/mason-lspconfig.nvim",
            opts = {
                ensure_installed = { 'lua_ls', 'pyright', 'clangd', 'ts_ls' }
            },
            dependencies = {
                { "mason-org/mason.nvim", opts = {} },
                "neovim/nvim-lspconfig",
            },
        },
        {
            'saghen/blink.cmp',
            -- optional: provides snippets for the snippet source
            dependencies = { 'rafamadriz/friendly-snippets' },

            -- use a release tag to download pre-built binaries
            version = '1.*',
            -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
            -- build = 'cargo build --release',
            -- If you use nix, you can build from source using latest nightly rust with:
            -- build = 'nix run .#build-plugin',

            ---@module 'blink.cmp'
            ---@type blink.cmp.Config
            opts = {
                -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
                -- 'super-tab' for mappings similar to vscode (tab to accept)
                -- 'enter' for enter to accept
                -- 'none' for no mappings
                --
                -- All presets have the following mappings:
                -- C-space: Open menu or open docs if already open
                -- C-n/C-p or Up/Down: Select next/previous item
                -- C-e: Hide menu
                -- C-k: Toggle signature help (if signature.enabled = true)
                --
                -- See :h blink-cmp-config-keymap for defining your own keymap
                keymap = { preset = 'default' },

                appearance = {
                    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                    -- Adjusts spacing to ensure icons are aligned
                    nerd_font_variant = 'mono'
                },

                -- (Default) Only show the documentation popup when manually triggered
                completion = { documentation = { auto_show = false } },

                -- Default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, due to `opts_extend`
                sources = {
                    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            -- make lazydev completions top priority (see `:h blink.cmp`)
                            score_offset = 100,
                        },
                    }
                },

                -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
                -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
                -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
                --
                -- See the fuzzy documentation for more information
                fuzzy = { implementation = "prefer_rust_with_warning" }
            },
            opts_extend = { "sources.default" }
        },
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        {
            "ibhagwan/fzf-lua",
            -- optional for icon support
            dependencies = { "nvim-tree/nvim-web-devicons" },
            -- or if using mini.icons/mini.nvim
            -- dependencies = { "nvim-mini/mini.icons" },
            ---@module "fzf-lua"
            ---@type fzf-lua.Config|{}
            ---@diagnostics disable: missing-fields
            opts = {}
            ---@diagnostics enable: missing-fields
        }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    -- @carlosdr02 changed this to false
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

vim.keymap.set('n', '<leader>mh', fzf.helptags, { desc = 'Misc help tags' })
vim.keymap.set('n', '<leader>mc', fzf.colorschemes, { desc = 'Misc colorschemes' })
vim.keymap.set('n', '<leader>mk', fzf.keymaps, { desc = 'Misc keymaps' })
vim.keymap.set('n', '<leader>ms', fzf.search_history, { desc = 'Misc search history' })
vim.keymap.set('n', '<leader>mo', fzf.nvim_options, { desc = 'Misc nvim options' })
