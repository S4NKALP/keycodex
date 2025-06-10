local util = require('lib.util')
local function load_config(package)
    return function()
        require('plugins.' .. package)
    end
end

local plugins = {
    -- UI
    {
        'navarasu/onedark.nvim',
        config = load_config('ui.onedark'),
        lazy = false,
        priority = 1000,
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
    {
        '2kabhishek/markit.nvim',
        config = load_config('ui.markit'),
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
        'windwp/nvim-ts-autotag',
        event = 'InsertEnter',
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
        'nvimtools/none-ls.nvim',
        dependencies = { 'jay-babu/mason-null-ls.nvim' },
        config = load_config('lang.null-ls'),
        event = { 'BufReadPost', 'BufNewFile' },
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'Kaiser-Yang/blink-cmp-avante',
            'L3MON4D3/LuaSnip',
            version = 'v2.*',
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
            'ravitemer/mcphub.nvim',
        },
    },
    {
        'ravitemer/mcphub.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = 'MCPHub',
        -- build = "npm install -g mcp-hub@latest", -- use this if you want to use the global mcp-hub
        build = 'bundled_build.lua',
        config = load_config('ai.mcphub'),
    },
    -- {
    --     'L3MON4D3/LuaSnip',
    --     dependencies = { 'rafamadriz/friendly-snippets' },
    --     config = function()
    --         -- Lazy load VSCode-style snippets (including JSON)
    --         require("luasnip.loaders.from_vscode").lazy_load({
    --             paths = {
    --                 vim.fn.stdpath('config') .. '/snippets',  -- your custom snippets folder
    --             },
    --         })
    --     end
    -- },

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
        'numToStr/Navigator.nvim',
        config = load_config('tools.navigator'),
        event = 'VeryLazy',
    },
    {
        'iamcco/markdown-preview.nvim',
        build = function()
            vim.fn['mkdp#util#install']()
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
        'cvigilv/esqueleto.nvim',
        event = 'VeryLazy',
        opts = {
            directories = {
                vim.fn.stdpath('config') .. '/templates',
            },
            patterns = {
                -- File
                'README',
                'LICENSE',
                -- Filetype
                'sh',
                'markdown',
                'python',
                'lua',
                'html',
                'vue',
            },
        },
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

    -- 2kabhishek
    {
        '2kabhishek/pickme.nvim',
        cmd = 'PickMe',
        event = 'VeryLazy',
        dependencies = {
            'folke/snacks.nvim',
            -- 'nvim-telescope/telescope.nvim',
            -- 'ibhagwan/fzf-lua',
        },
        opts = {
            picker_provider = 'snacks',
        },
    },
    {
        '2kabhishek/termim.nvim',
        cmd = { 'Fterm', 'FTerm', 'Sterm', 'STerm', 'Vterm', 'VTerm' },
    },
    {
        '2kabhishek/octohub.nvim',
        cmd = {
            'OctoRepos',
            'OctoReposByCreated',
            'OctoReposByForks',
            'OctoReposByIssues',
            'OctoReposByLanguages',
            'OctoReposByNames',
            'OctoReposByPushed',
            'OctoReposBySize',
            'OctoReposByStars',
            'OctoReposByUpdated',
            'OctoReposTypeArchived',
            'OctoReposTypeForked',
            'OctoReposTypePrivate',
            'OctoReposTypeStarred',
            'OctoReposTypeTemplate',
            'OctoRepo',
            'OctoStats',
            'OctoActivityStats',
            'OctoContributionStats',
            'OctoRepoStats',
            'OctoProfile',
            'OctoRepoWeb',
        },
        keys = {
            '<leader>goa',
            '<leader>goA',
            '<leader>gob',
            '<leader>goc',
            '<leader>gof',
            '<leader>goF',
            '<leader>gog',
            '<leader>goi',
            '<leader>gol',
            '<leader>goo',
            '<leader>gop',
            '<leader>goP',
            '<leader>gor',
            '<leader>gos',
            '<leader>goS',
            '<leader>got',
            '<leader>goT',
            '<leader>gou',
            '<leader>goU',
            '<leader>gow',
        },
        dependencies = {
            '2kabhishek/utils.nvim',
        },
        config = load_config('tools.octohub'),
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
        'JohnnyJumper/neotypist.nvim',
        opts = {
            notify_interval = 60 * 100, -- one minute
            high = 80,
            low = 20,
            show_virt_text = true,
            notify = true,
            update_time = 300,
            virt_text = function(wpm)
                return ('🚀 WPM: %.0f'):format(wpm)
            end,
            virt_text_pos = 'right_align',
        },
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

local null_ls_sources = {
    'shellcheck',
}

local lsp_servers = {
    'bashls',
    'jsonls',
    'typos_lsp',
    'vimls',
    'lua_ls',
    'tailwindcss', -- Add Tailwind CSS LSP
}

if util.is_present('npm') then
    table.insert(lsp_servers, 'eslint')
    table.insert(lsp_servers, 'ts_ls')
end

if util.is_present('gem') then
    table.insert(lsp_servers, 'solargraph')
    table.insert(lsp_servers, 'rubocop')
end

if util.is_present('go') then
    table.insert(lsp_servers, 'gopls')
end

if util.is_present('dart') then
    table.insert(lsp_servers, 'dartls')
end

if util.is_present('java') then
    table.insert(lsp_servers, 'jdtls')
end

if util.is_present('pip') then
    table.insert(lsp_servers, 'ruff')
    table.insert(lsp_servers, 'pylsp')
end

if util.is_present('mix') then
    table.insert(lsp_servers, 'elixirls')
end

if util.is_present('cargo') then
    table.insert(lsp_servers, 'rust_analyzer')
end

plugins = vim.tbl_extend('force', plugins, util.get_user_config('user_plugins', {}))
lsp_servers = vim.tbl_extend('force', lsp_servers, util.get_user_config('user_lsp_servers', {}))
null_ls_sources = vim.tbl_extend('force', null_ls_sources, util.get_user_config('user_null_ls_sources', {}))
treesitter_parsers = vim.tbl_extend('force', treesitter_parsers, util.get_user_config('user_tresitter_parsers', {}))

return {
    plugins = plugins,
    lsp_servers = lsp_servers,
    null_ls_sources = null_ls_sources,
    ts_parsers = treesitter_parsers,
}
