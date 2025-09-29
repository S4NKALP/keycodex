return {
    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('nvim-treesitter').setup({
                ensure_installed = {
                    'c',
                    'markdown',
                    'python',
                    'java',
                    'cpp',
                    'bash',
                    'lua',
                    'make',
                    'latex',
                    'json',
                    'jsonc',
                    'sql',
                    'yaml',
                    'toml',
                    'javascript',
                    'typescript',
                    'gitignore',
                    'go',
                    'rust',
                    'html',
                    'css',
                    'scss',
                    'markdown_inline',
                },
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

    {
        'danymat/neogen',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
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

    -- auto pairs
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            local npairs = require('nvim-autopairs')
            local Rule = require('nvim-autopairs.rule')
            local cond = require('nvim-autopairs.conds')

            npairs.setup({
                check_ts = true,
            })

            -- Your existing LaTeX rule
            npairs.add_rules({
                Rule('$', '$', { 'tex', 'latex', 'plaintex' }):with_move(cond.none()),
            })

            npairs.add_rules({
                Rule(' ', ' '):with_pair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.tbl_contains({ '()', '[]', '{}' }, pair)
                end),
            })
        end,
    },

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

    {
        'Wansmer/treesj',
        keys = { '<space>m', '<space>j', '<space>s' },
        dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
        config = function()
            require('treesj').setup()
        end,
    },
}
