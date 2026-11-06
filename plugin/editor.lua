add({
    'saghen/blink.lib',
    { src = 'saghen/blink.cmp', build = 'cargo build --release' },
    'rafamadriz/friendly-snippets',
    'numToStr/Navigator.nvim', -- navigator
    'm4xshen/hardtime.nvim', -- workflow
    'mg979/vim-visual-multi', -- multiple cursors
    'NMAC427/guess-indent.nvim', -- auto-detect tab/space indentation
    'kevinhwang91/nvim-hlslens',
    'abecodes/tabout.nvim',
})

vim.g.VM_maps = {
    ['Find Under'] = '<M-d>', -- Alt + d | Select word under cursor and start multi-cursor
    ['Find Subword Under'] = '<M-d>', -- Alt + d | Select subword under cursor
    ['Select All'] = '<C-M-d>', -- Ctrl + Alt + d | Select all occurrences in the buffer
    ['Add Cursor Down'] = '<C-M-j>', -- Ctrl + Alt + j | Add a cursor on the line below
    ['Add Cursor Up'] = '<C-M-k>', -- Ctrl + Alt + k | Add a cursor on the line above
}

require('guess-indent').setup({})
require('hlslens').setup()
require('tabout').setup({})
require('hardtime').setup({})
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

require('Navigator').setup({
    auto_save = 'current',
    disable_on_zoom = false,
    mux = 'auto',
})
