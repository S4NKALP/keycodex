return {
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
        config = function()
            require('nvim-ts-autotag').setup({
                enable_close = true,
                enable_rename = true,
                enable_close_on_slash = true,
            })
        end,
    },
}
