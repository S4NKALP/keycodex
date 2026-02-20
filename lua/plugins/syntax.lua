return {

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = require('config.extensions').ts_parsers,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },

    -- auto pairs
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            local npairs = require('nvim-autopairs')
            local Rule = require('nvim-autopairs.rule')
            local conds = require('nvim-autopairs.conds')

            npairs.setup()

            -- Autoclosing angle-brackets.
            npairs.add_rule(Rule('<', '>', {
                -- Avoid conflicts with nvim-ts-autotag.
                '-html',
                '-javascriptreact',
                '-typescriptreact',
            }):with_pair(conds.before_regex('%a+:?:?$', 3)):with_move(function(opts)
                return opts.char == '>'
            end))
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
        opts = {
            -- Defaults
            enable_close = true,           -- Auto close tags
            enable_rename = true,          -- Auto rename pairs of tags
            enable_close_on_slash = false, -- Auto close on trailing </
        },
    },

    -- syntax highlight for mdx
    {
        'davidmh/mdx.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
}
