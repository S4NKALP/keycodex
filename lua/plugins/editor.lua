return {

    {
        'zbirenbaum/neodim',
        enabled = false,
        event = 'LspAttach',
        config = function()
            require('neodim').setup({
                alpha = 0.5,
                blend_color = nil,
                hide = {
                    underline = true,
                    virtual_text = true,
                    signs = true,
                },
                regex = {
                    '[uU]nused',
                    '[nN]ever [rR]ead',
                    '[nN]ot [rR]ead',
                },
                priority = 128,
                disable = {},
            })
        end,
    },

    -- comment
    {
        'numToStr/Comment.nvim',
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        config = function()
            require('Comment').setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
                mappings = {
                    basic = true,
                    extra = true,
                },
            })
            ft = require('Comment.ft')
            ft.set('typescriptreact', { '//%s', '{/*%s*/}' })
        end,
        keys = {
            { 'gcc', mode = 'n',          desc = 'Toggle comment line' },
            { 'gc',  mode = { 'n', 'o' }, desc = 'Toggle comment linewise' },
            { 'gc',  mode = 'x',          desc = 'Toggle comment linewise (visual)' },
            { 'gbc', mode = 'n',          desc = 'Toggle comment block' },
            { 'gb',  mode = { 'n', 'o' }, desc = 'Toggle comment blockwise' },
            { 'gb',  mode = 'x',          desc = 'Toggle comment blockwise (visual)' },
        },
    },

    -- Todo Comments
    {
        'folke/todo-comments.nvim',
        event = 'BufRead',
        opts = {},
    },

    -- visual multi
    {
        'mg979/vim-visual-multi',
        event = 'VeryLazy',
        init = function()
            vim.g.VM_maps = {
                ['Find Under'] = '<M-d>',
                ['Find Subword Under'] = '<M-d>',
                ['Select All'] = '<C-M-d>',
                ['Add Cursor Down'] = '<C-M-j>',
                ['Add Cursor Up'] = '<C-M-k>',
            }
        end,
    },
}
