return {

    -- Todo Comments
    {
        'folke/todo-comments.nvim',
        event = 'BufRead',
        opts = {},
    },

    -- Working with file permissions
    {
        'lambdalisue/vim-suda',
        cmd = { 'SudaRead', 'SudaWrite' },
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

    -- dimming the highlights of unused functions, variables, parameters, and more
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

    -- file operations
    {
        'chrisgrieser/nvim-genghis',
        keys = {
            {
                '<leader>fn',
                function()
                    require('genghis').createNewFile()
                end,
                desc = 'New File',
            },
            {
                '<leader>fd',
                function()
                    require('genghis').duplicateFile()
                end,
                desc = 'Duplicate File',
            },
            {
                '<leader>fr',
                function()
                    require('genghis').renameFile()
                end,
                desc = 'Rename File',
            },
            {
                '<leader>fz',
                function()
                    require('genghis').chmodx()
                end,
                desc = 'Make Executable',
            },
        },
    },

    -- markdown preview
    {
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
}
