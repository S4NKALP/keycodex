return {

    -- rendering for html, latex, md
    {
        'OXY2DEV/markview.nvim',
        lazy = false,
        -- to load before treesitter
        priority = 45,
        config = function()
            require('markview').setup({
                markdown = {
                    code_blocks = { sign = false },
                },
            })
        end,
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
        opts = {
            provider_selector = function()
                return { 'lsp', 'indent' }
            end,
            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ('  … %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, 'MoreMsg' })
                return newVirtText
            end,
            open_fold_hl_timeout = 0,
        },
        keys = {
            { 'fd', 'zd', desc = 'Delete fold under cursor' },
            { 'fo', 'zo', desc = 'Open fold under cursor' },
            { 'fO', 'zO', desc = 'Open all folds under cursor' },
            { 'fc', 'zC', desc = 'Close all folds under cursor' },
            { 'fa', 'za', desc = 'Toggle fold under cursor' },
            { 'fA', 'zA', desc = 'Toggle all folds under cursor' },
            { 'fv', 'zv', desc = 'Show cursor line' },
            {
                'fM',
                function()
                    require('ufo').closeAllFolds()
                end,
                desc = 'Close all folds',
            },
            {
                'fR',
                function()
                    require('ufo').openAllFolds()
                end,
                desc = 'Open all folds',
            },
            {
                'fm',
                function()
                    require('ufo').closeFoldsWith()
                end,
                desc = 'Fold more',
            },
            {
                'fr',
                function()
                    require('ufo').openFoldsExceptKinds()
                end,
                desc = 'Fold less',
            },
            { 'fx', 'zx', desc = 'Update folds' },
            { 'fz', 'zz', desc = 'Center this line' },
            { 'ft', 'zt', desc = 'Top this line' },
            { 'fb', 'zb', desc = 'Bottom this line' },
            { 'fg', 'zg', desc = 'Add word to spell list' },
            { 'fw', 'zw', desc = 'Mark word as bad/misspelling' },
            { 'fe', 'ze', desc = 'Right this line' },
            { 'fE', 'zE', desc = 'Delete all folds in current buffer' },
            { 'fs', 'zs', desc = 'Left this line' },
            { 'fH', 'zH', desc = 'Half screen to the left' },
            { 'fL', 'zL', desc = 'Half screen to the right' },
        },
    },
}
