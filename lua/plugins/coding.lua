return {

    -- completion
    {
        'saghen/blink.cmp',
        version = '*',
        config = function()
            require('blink.cmp').setup({
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
                        draw = {
                            components = {
                                kind_icon = {
                                    text = function(ctx)
                                        local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                        return kind_icon
                                    end,
                                    highlight = function(ctx)
                                        local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                        return hl
                                    end,
                                },
                                kind = {
                                    highlight = function(ctx)
                                        local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                                        return hl
                                    end,
                                },
                            },
                        },
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

    -- snippets
    {
        'L3MON4D3/LuaSnip',
        version = '*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
            local luasnip = require('luasnip')
            require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_vscode').lazy_load({
                paths = { vim.fn.stdpath('config') .. '/snippets' },
            })

            luasnip.filetype_extend('mdx', { 'markdown' })
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

    -- annotation generator
    {
        'danymat/neogen',
        opts = {
            snippet_engine = 'luasnip',
            languages = {
                python = {
                    template = {
                        annotation_convention = 'google_docstrings',
                    },
                },
            },
        },
    },

    -- syntax highlight for mdx
    {
        'davidmh/mdx.nvim',
        config = true,
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
}
