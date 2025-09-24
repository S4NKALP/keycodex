return {
    -- snippets
    {
        'L3MON4D3/LuaSnip',
        version = '*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
            local luasnip = require('luasnip')

            require('luasnip.loaders.from_vscode').lazy_load({
                paths = { vim.fn.stdpath('config') .. '/snippets' },
            })

            luasnip.filetype_extend('mdx', { 'markdown' })
        end,
    },

    -- completion
    {
        'saghen/blink.cmp',
        version = '*',
        dependencies = {
            'L3MON4D3/LuaSnip',
        },
        config = function()
            require('blink.cmp').setup({
                appearance = {
                    kind_icons = {
                        Text = '',
                        Method = '',
                        Function = 'ƒ',
                        Constructor = '',
                        Field = '',
                        Variable = '',
                        Property = '󰓹',
                        Class = '',
                        Interface = '',
                        Struct = '',
                        Module = '󰩦',
                        Unit = '',
                        Value = '',
                        Enum = '',
                        EnumMember = '',
                        Keyword = '',
                        Constant = 'П',
                        Snippet = '',
                        Color = '',
                        File = '',
                        Reference = '',
                        Folder = '',
                        Event = '',
                        Operator = '',
                        TypeParameter = '',
                    },
                },
                completion = {
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
                    },
                },
                signature = {
                    window = { border = 'rounded' },
                },
                snippets = { preset = 'luasnip' },
                sources = {
                    default = { 'lsp', 'path', 'snippets', 'buffer' },
                    providers = {},
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
        end,
    },
}
