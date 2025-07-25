local util = require('lib.util')
local function load_config(package)
    return function()
        require('plugins.' .. package)
    end
end

local plugins = {
    -- UI
    {
        'nvchad/ui',
        config = function()
            require('nvchad')
        end,
    },
    {
        'nvchad/base46',
        lazy = false,
        priority = 1000,
        build = function()
            require('base46').load_all_highlights()
        end,
        config = function()
            require('base46').load_all_highlights()
        end,
    },
    { 'nvim-tree/nvim-web-devicons' },
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        config = load_config('ui.snacks'),
    },
    {
        'nvim-lualine/lualine.nvim',
        config = load_config('ui.lualine'),
        event = { 'BufReadPost', 'BufNewFile' },
    },
    {
        'folke/which-key.nvim',
        config = load_config('ui.which-key'),
        event = 'VeryLazy',
    },
    {
        'lewis6991/gitsigns.nvim',
        config = load_config('ui.gitsigns'),
        cmd = 'Gitsigns',
        event = { 'BufReadPost', 'BufNewFile' },
    },

    -- Editor
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-refactor',
            'nvim-treesitter/nvim-treesitter-textobjects',
            'RRethy/nvim-treesitter-textsubjects',
        },
        config = load_config('editor.treesitter'),
        event = { 'BufReadPost', 'BufNewFile' },
    },

    {
        'echasnovski/mini.bracketed',
        config = load_config('editor.bracketed'),
        event = { 'BufReadPost', 'BufNewFile' },
    },
    {
        'echasnovski/mini.pairs',
        config = load_config('editor.pairs'),
        event = 'InsertEnter',
    },
    {
        'echasnovski/mini.surround',
        version = '*',
        config = load_config('editor.surround'),
        event = { 'BufReadPost', 'BufNewFile' },
    },
    {
        'echasnovski/mini.ai',
        version = '*',
        config = load_config('editor.ai'),
        event = { 'BufReadPost', 'BufNewFile' },
    },
    {
        'Wansmer/treesj',
        keys = { '<space>m', '<space>j', '<space>s' },
        dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
        config = function()
            require('treesj').setup()
        end,
    },
    {
        'chrisgrieser/nvim-spider',
        config = load_config('editor.spider'),
        event = { 'BufReadPost', 'BufNewFile' },
    },
    -- Language
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = load_config('lang.lspconfig'),
        event = { 'BufReadPre', 'BufNewFile' },
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
    },
    {
        'nvimdev/lspsaga.nvim',
        config = load_config('lang.lspsaga'),
        event = 'LspAttach',
    },
    {
        'williamboman/mason.nvim',
        config = load_config('lang.mason'),
        cmd = 'Mason',
    },
    {
        'stevearc/conform.nvim',
        dependencies = { 'zapling/mason-conform.nvim' },
        config = load_config('lang.conform'),
        event = { 'BufReadPre', 'BufNewFile' },
    },
    {
        'mfussenegger/nvim-lint',
        dependencies = { 'rshkarin/mason-nvim-lint' },
        init = function()
            if vim.fn.executable('codespell') == 1 then
                vim.o.spell = false
            end
        end,
        config = load_config('lang.nvim-lint'),
        event = { 'BufReadPost', 'BufNewFile' },
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'Kaiser-Yang/blink-cmp-avante',
            'ribru17/blink-cmp-spell',
            {
                'L3MON4D3/LuaSnip',
                config = function()
                    -- Lazy load VSCode-style snippets (including JSON)
                    require('luasnip.loaders.from_vscode').lazy_load({
                        paths = {
                            vim.fn.stdpath('config') .. '/snippets', -- your custom snippets folder
                        },
                    })
                end,
            },
        },

        version = '*',
        config = load_config('lang.blink'),
        opts_extend = { 'sources.default' },
        event = { 'InsertEnter' },
    },
    {
        'mg979/vim-visual-multi',
        branch = 'master', -- Required to avoid loading the legacy branch
        event = { 'BufReadPost', 'BufNewFile' }, -- Load earlier when buffer is ready
        init = function()
            vim.g.VM_leader = '\\'
            vim.g.VM_maps = {
                ['Find Under'] = '<C-d>', -- Changed to match VSCode
                ['Find Subword Under'] = '<C-d>', -- Changed to match VSCode
                ['Select All'] = '<M-a>',
                ['Add Cursor Down'] = '<C-S-Down>', -- More intuitive than <C-j>
                ['Add Cursor Up'] = '<C-S-Up>', -- More intuitive than <C-k>
                ['Select Cursor Down'] = '<C-S-Down>',
                ['Select Cursor Up'] = '<C-S-Up>',
            }
            -- Keep default mappings for better functionality
            vim.g.VM_default_mappings = 1
        end,
    },

    -- AI
    {
        'zbirenbaum/copilot.lua',
        dependencies = { 'giuxtaposition/blink-cmp-copilot' },
        config = load_config('ai.copilot'),
        event = 'InsertEnter',
    },
    {
        'yetone/avante.nvim',
        version = false,
        config = load_config('ai.avante'),
        event = { 'BufReadPost', 'BufNewFile' },
        build = 'make',
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            'MunifTanjim/nui.nvim',
            'nvim-lua/plenary.nvim',
        },
    },

    -- Tools
    {
        'echasnovski/mini.files',
        version = '*',
        config = load_config('tools.files'),
        event = { 'BufReadPost', 'BufNewFile' },
        keys = {
            {
                '<leader>ee',
                function()
                    require('mini.files').open(util.get_file_path(), true)
                end,
                desc = 'Explorer',
            },
        },
    },
    {
        'michaelb/sniprun',
        build = 'bash ./install.sh',
        config = load_config('tools.sniprun'),
        cmd = 'SnipRun',
    },
    {
        'windwp/nvim-spectre',
        config = load_config('tools.spectre'),
        cmd = 'Spectre',
    },
    {
        'folke/flash.nvim',
        config = load_config('tools.flash'),
        keys = {
            {
                's',
                mode = { 'n', 'x', 'o' },
                function()
                    require('flash').jump()
                end,
                desc = 'Flash',
            },
            {
                'S',
                mode = { 'n', 'x', 'o' },
                function()
                    require('flash').treesitter()
                end,
                desc = 'Flash Treesitter',
            },
        },
    },
    {
        'windwp/nvim-ts-autotag',
        ft = {
            'html',
            'javascriptreact',
            'typescriptreact',
            'svelte',
            'vue',
            'tsx',
            'jsx',
            'markdown',
            'handlebars',
            'hbs',
        },
        opts = {},
    },
    {
        'gbprod/substitute.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local substitute = require('substitute')

            substitute.setup()

            -- set keymaps
            local keymap = vim.keymap -- for conciseness

            keymap.set('n', 's', substitute.operator, { desc = 'Substitute with motion' })
            keymap.set('n', 'ss', substitute.line, { desc = 'Substitute line' })
            keymap.set('n', 'S', substitute.eol, { desc = 'Substitute to end of line' })
            keymap.set('x', 's', substitute.visual, { desc = 'Substitute in visual mode' })
        end,
    },
    {
        'davidmh/mdx.nvim',
        config = true,
        lazy = false,
    },
    {
        'numToStr/Navigator.nvim',
        config = load_config('tools.navigator'),
        event = 'VeryLazy',
    },
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
        'uga-rosa/ccc.nvim',
        config = load_config('tools.ccc'),
        cmd = { 'CccHighlighterToggle', 'CccConvert', 'CccPick' },
    },
    {
        'ruifm/gitlinker.nvim',
        config = load_config('tools.gitlinker'),
        keys = '<leader>yg',
    },
    {
        'tpope/vim-fugitive',
        cmd = 'Git',
    },
    {

        'akinsho/toggleterm.nvim',
        cmd = { 'ToggleTerm' },
        version = 'v2.*',
        config = load_config('tools.toggleterm'),
    },
    {
        'mistricky/codesnap.nvim',
        lazy = true,
        build = 'make',
        opts = {
            save_path = '~/Pictures/code-screenshots/',
            has_breadcrumbs = false,
            show_workspace = false,
            bg_theme = 'default',
            watermark = 'S4NKALP',
            code_font_family = 'Iosevka NF',
            code_font_size = 12,
        },
        cmd = { 'CodeSnap', 'CodeSnapSave', 'CodeSnapHighlight', 'CodeSnapASCII' },
    },
    {
        'LudoPinelli/comment-box.nvim',
        event = 'BufReadPre',
        opts = {
            box_width = 70,
        },
    },
    {
        'mistricky/codesnap.nvim',
        lazy = true,
        build = 'make',
        opts = {
            save_path = '~/Pictures/screenshots/code',
            has_breadcrumbs = false,
            show_workspace = false,
            bg_theme = 'default',
            watermark = 'S4NKALP',
            code_font_family = 'Iosevka NF',
            code_font_size = 12,
        },
        cmd = { 'CodeSnap', 'CodeSnapSave', 'CodeSnapHighlight', 'CodeSnapASCII' },
    },
    {
        'jeryldev/pyworks.nvim',
        lazy = false, -- Load immediately for autocmds
        config = function()
            require('pyworks').setup({
                python = {
                    preferred_venv_name = '.venv',
                    use_uv = true, -- Use uv when available
                },
                auto_activate_venv = true,
            })
        end,
    },
    {
        'folke/todo-comments.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            {
                '<leader>tt',
                function()
                    require('snacks').picker.todo_comments({ keywords = { 'TODO' } })
                end,
                desc = 'Todo',
            },
            {
                '<leader>tf',
                function()
                    require('snacks').picker.todo_comments({
                        keywords = { 'FIX', 'FIXME' },
                    })
                end,
                desc = 'Fix/Fixme',
            },
            {
                '<leader>tn',
                function()
                    require('snacks').picker.todo_comments({ keywords = { 'NOTE' } })
                end,
                desc = 'Note',
            },
        },
        config = function()
            local todo_comments = require('todo-comments')

            todo_comments.setup({
                keywords = {
                    FIX = {
                        icon = ' ', -- icon used for the sign, and in search results
                        color = 'error', -- can be a hex color, or a named color (see below)
                        alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
                        -- signs = false, -- configure signs for some keywords individually
                    },
                    TODO = { icon = ' ', color = 'info' },
                    HACK = { icon = ' ', color = 'warning', alt = { 'DON SKIP' } },
                    WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
                    PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
                    NOTE = { icon = ' ', color = 'hint', alt = { 'INFO', 'READ', 'COLORS' } },
                    TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
                },
            })

            -- keymaps
            vim.keymap.set('n', ']t', function()
                todo_comments.jump_next()
            end, { desc = 'Next todo comment' })

            vim.keymap.set('n', '[t', function()
                todo_comments.jump_prev()
            end, { desc = 'Previous todo comment' })
        end,
    },
    {
        '2kabhishek/pickme.nvim',
        cmd = 'PickMe',
        event = 'VeryLazy',
        dependencies = {
            'folke/snacks.nvim',
        },
        opts = {
            picker_provider = 'snacks',
        },
    },
    {
        '2kabhishek/termim.nvim',
        cmd = { 'Fterm', 'FTerm', 'Sterm', 'STerm', 'Vterm', 'VTerm' },
    },

    -- Optional
    {
        'sphamba/smear-cursor.nvim',
        event = 'VeryLazy',
        cond = vim.g.neovide == nil,
        opts = {
            stiffness = 0.5,
            trailing_stiffness = 0.49,
        },
        enabled = util.get_user_config('enable_smear_cursor', false),
    },
    {
        'nvzone/showkeys',
        cmd = 'ShowkeysToggle',
        opts = {
            timeout = 1,
            maxkeys = 10,
            -- more opts
        },
    },
    {
        'wakatime/vim-wakatime',
        event = { 'VimEnter' },
        lazy = false,
        enabled = util.get_user_config('enable_wakatime', false),
    },
    {
        'm4xshen/hardtime.nvim',
        dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
        cmd = 'Hardtime',
        enabled = util.get_user_config('enable_trainer', false),
    },
    {
        'kndndrj/nvim-dbee',
        dependencies = { 'MunifTanjim/nui.nvim' },
        build = function()
            --    "curl", "wget", "bitsadmin", "go"
            require('dbee').install('curl')
        end,
        config = load_config('tools.dbee'),
        cmd = 'DBToggle',
        enabled = util.get_user_config('enable_db_explorer', false),
    },
    {
        'mfussenegger/nvim-dap',
        dependencies = { 'rcarriga/nvim-dap-ui' },
        config = load_config('tools.dap'),
        cmd = { 'DapUIToggle', 'DapToggleRepl', 'DapToggleBreakpoint' },
        enabled = util.get_user_config('enable_debugger', false),
    },
    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-neotest/nvim-nio',
            'olimorris/neotest-rspec',
            'nvim-neotest/neotest-jest',
            'nvim-neotest/neotest-python',
        },
        config = load_config('tools.neotest'),
        cmd = 'Neotest',
        enabled = util.get_user_config('enable_test_runner', false),
    },
}

local treesitter_parsers = {
    'bash',
    'css',
    'dart',
    'elixir',
    'gitcommit',
    'go',
    'html',
    'java',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline', -- markdown code blocks
    'python',
    'ruby',
    'rust',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
}

local linter_sources = {
    'shellcheck',
    'write_good',
    'markdownlint',
    'eslint_d',
    'hadolint',
    'actionlint',
    'vint',
    'codespell',
    'editorconfig-checker',
}

local formatter_sources = {
    'prettier',
    'shfmt',
    'stylua',
}

local lsp_servers = {
    'bashls',
    'jsonls',
    'typos_lsp',
    'vimls',
    'lua_ls',
    'qmlls',
    'tailwindcss',
    'ts_ls',
    'pyright',
}

if util.is_present('npm') then
    table.insert(lsp_servers, 'eslint')
    table.insert(lsp_servers, 'ts_ls')
end

if util.is_present('go') then
    table.insert(lsp_servers, 'gopls')
end

if util.is_present('java') then
    table.insert(lsp_servers, 'jdtls')
end

if util.is_present('pip') then
    table.insert(lsp_servers, 'ruff')
    table.insert(lsp_servers, 'pylsp')
end

if util.is_present('cargo') then
    table.insert(lsp_servers, 'rust_analyzer')
end

plugins = vim.tbl_extend('force', plugins, util.get_user_config('user_plugins', {}))
lsp_servers = vim.tbl_extend('force', lsp_servers, util.get_user_config('user_lsp_servers', {}))
formatter_sources = vim.tbl_extend('force', formatter_sources, util.get_user_config('user_formatter_sources', {}))
linter_sources = vim.tbl_extend('force', linter_sources, util.get_user_config('user_linter_sources', {}))
treesitter_parsers = vim.tbl_extend('force', treesitter_parsers, util.get_user_config('user_tresitter_parsers', {}))

return {
    plugins = plugins,
    lsp_servers = lsp_servers,
    formatter_sources = formatter_sources,
    linter_sources = linter_sources,
    ts_parsers = treesitter_parsers,
}
