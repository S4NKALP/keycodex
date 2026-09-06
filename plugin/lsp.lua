add({
    'mason-org/mason.nvim', -- lsp installer manager
    'mason-org/mason-lspconfig.nvim', -- lsp installer
    'neovim/nvim-lspconfig', -- lsp config
    'rachartier/tiny-inline-diagnostic.nvim', -- inline diagnostic
    'rachartier/tiny-code-action.nvim', -- code action
    'saghen/blink.lib',
    { src = 'saghen/blink.cmp', build = 'cargo build --release' },
    'rafamadriz/friendly-snippets',
})

require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust' },
    snippets = { preset = 'default' },
    sources = {
        default = function()
            local type = vim.fn.getcmdtype()
            if type == '/' or type == '?' then
                return { 'buffer' }
            end
            if type == ':' then
                return { 'cmdline' }
            end
            return { 'lsp', 'path', 'snippets', 'buffer' }
        end,
        providers = {
            snippets = {
                opts = {
                    search_paths = { vim.fn.stdpath('config') .. '/snippets' },
                    extended_filetypes = { mdx = { 'markdown' } },
                },
            },
        },
    },

    completion = {
        ghost_text = { enabled = true },

        list = {
            selection = {
                preselect = false,
                auto_insert = true,
            },
        },
        documentation = {
            window = { border = 'rounded' },
            auto_show = true,
            auto_show_delay_ms = 50,
        },
        menu = {
            border = 'rounded',
            draw = {
                components = {
                    kind_icon = {
                        text = function(ctx)
                            local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                            return kind_icon
                        end,
                        highlight = function(ctx)
                            local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                            return hl
                        end,
                    },
                    kind = {
                        highlight = function(ctx)
                            local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                            return hl
                        end,
                    },
                },
            },
        },
    },
    signature = {
        window = { border = 'rounded' },
    },
    keymap = {
        preset = 'none',
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-space>'] = { 'hide', 'show' },
        ['<C-y>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },
})

-- lsp installer
require('mason').setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
        border = 'rounded',
        backdrop = 100,
    },
})

require('mason-lspconfig').setup({
    ensure_installed = require('extensions').lsp_server,
    automatic_installation = false, -- Don't auto-install or auto-configure
})

-- improve neovim lsp experience
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function()
        --inline diagnostic
        require('tiny-inline-diagnostic').setup({
            options = {
                show_source = true,
                multiple_diag_under_cursor = true,
            },
        })

        --code action
        require('tiny-code-action').setup({
            picker = {
                'buffer',
                opts = {
                    auto_preview = true,
                    hotkeys = true,
                    hotkeys_mode = 'sequential',
                },
            },
        })
    end,
})

vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
vim.keymap.set('n', '<leader>.', function()
    require('tiny-code-action').code_action()
end, { desc = 'Code action' })
