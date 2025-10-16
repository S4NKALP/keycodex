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

    -- fold
    {
        'kevinhwang91/nvim-ufo',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'kevinhwang91/promise-async', event = 'BufReadPost' },
        config = function()
            require('ufo').setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end,
            })
        end,
    },
}
