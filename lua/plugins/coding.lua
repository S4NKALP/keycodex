return {
    -- auto pairs
    {
        'windwp/nvim-autopairs',
        enabled = false,
        event = 'InsertEnter',
        config = function()
            local npairs = require('nvim-autopairs')

            npairs.setup({
                check_ts = true,
                enable_check_bracket_line = true,
                fast_wrap = {},
                map_cr = true,
                map_bs = true,
            })
        end,
    },

    -- auto tag
    {
        'windwp/nvim-ts-autotag',
        ft = {
            'html',
            'xml',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'jsx',
            'tsx',
            'vue',
            'svelte',
            'markdown',
            'htmldjango',
        },
        event = 'InsertEnter',
        lazy = true,
        config = function()
            require('nvim-ts-autotag').setup({
                enable_close = true,
                enable_rename = true,
                enable_close_on_slash = true,
            })
        end,
    },
}
