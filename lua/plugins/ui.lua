return {

    -- rendering for html, latex, md
    {
        'OXY2DEV/markview.nvim',
        lazy = false,
        -- to load before treesitter
        priority = 45,
        opts = {
            preview = {
                enable = false,
            },
        },
        keys = {
            { '<leader>cv', '<Cmd>Markview toggle<CR>', desc = 'Toggle markdown preview', mode = 'n' },
        },
    },

    -- markdown preview
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && yarn install',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        ft = 'markdown',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview' },
    },

    -- Better folding
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'BufReadPost',
        keys = {
            {
                'zR',
                function()
                    require('ufo').openAllFolds()
                end,
            },
            {
                'zM',
                function()
                    require('ufo').closeAllFolds()
                end,
            },
            {
                'zr',
                function()
                    require('ufo').openFoldsExceptKinds()
                end,
            },
            {
                'zm',
                function()
                    require('ufo').closeFoldsWith()
                end,
            },
        },
        config = function()
            vim.o.foldcolumn = '1'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            require('ufo').setup({
                provider_selector = function()
                    return { 'treesitter', 'indent' }
                end,
            })
        end,
    },

    -- Undo tree
    {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        keys = { { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Undo Tree' } },
    },
}
