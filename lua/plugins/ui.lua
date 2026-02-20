return {

    -- rendering for html and markdown
    {
        'OXY2DEV/markview.nvim',
        lazy = false,
        -- to load before treesitter
        priority = 45,
        config = function()
            require('markview').setup({
                preview = {
                    icon_provider = 'mini',
                    enable = false,
                },
            })
        end,
        keys = {
            { '<leader>cv', '<Cmd>Markview toggle<CR>', desc = 'Toggle markdown preview', mode = 'n' },
        },
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

    -- smooth scrolling
    {
        'karb94/neoscroll.nvim',
        opts = {},
    },

    -- Smart column (colorcolumn only when needed)
    {
        'm4xshen/smartcolumn.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            colorcolumn = '120',
            disabled_filetypes = {
                'help',
                'text',
                'markdown',
                'dashboard',
                'snacks_dashboard',
                'lazy',
                'mason',
                'oil',
            },
        },
    },

    -- Screenshot Tool
    {
        'mistricky/codesnap.nvim',
        build = 'make',
        cmd = {
            'CodeSnap',
            'CodeSnapSave',
            'CodeSnapHighlight',
            'CodeSnapSaveHighlight',
            'CodeSnapASCII',
        },
        opts = {
            bg_theme = 'dusk',
            code_font_family = 'JetBrainsMono Nerd Font',
            save_path = os.getenv('XDG_SCREENSHOTS_DIR') or (os.getenv('HOME') .. '/Pictures'),
            watermark = 'SANKALP',
            watermark_font_family = 'Anurati',
            has_breadcrumbs = true,
            breadcrumbs_separator = '/',
            has_line_number = true,
        },
    },
}
