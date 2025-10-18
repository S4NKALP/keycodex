return {
    -- default lsp configs
    {
        'neovim/nvim-lspconfig',
        config = function() end,
    },

    -- lsp installer
    {
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
        },
        cmd = 'Mason',
        config = function()
            -- mason
            require('mason').setup({
                ui = {
                    icons = {
                        package_installed = '✓',
                        package_pending = '➜',
                        package_uninstalled = '✗',
                    },
                    border = 'rounded',
                    backdrop = 100,
                },
            })
            require('mason-lspconfig').setup({
                ensure_installed = require('config.extensions').lsp_server,
                automatic_installation = false, -- Don't auto-install or auto-configure
            })
        end,
    },

    -- improve neovim lsp experience
    {
        'nvimdev/lspsaga.nvim',
        event = 'LspAttach',
        config = function()
            require('lspsaga').setup({
                ui = {
                    theme = 'round',
                    border = 'rounded',
                    devicon = true,
                    title = true,
                    winblend = 1,
                    expand = ' ',
                    collapse = ' ',
                    preview = '',
                    code_action = '󰠠 ',
                    diagnostic = ' ',
                    incoming = ' ',
                    outgoing = ' ',
                    hover = ' ',
                },
            })
        end,
    },

    -- inline diagnostic
    {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = 'VeryLazy',
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup({
                options = {
                    show_source = true,
                    multiple_diag_under_cursor = true,
                    -- break_line = {
                    -- 	enabled = true,
                    -- 	after = 60,
                    -- }
                },
            })
            vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
        end,
    },

    -- code action
    {
        'rachartier/tiny-code-action.nvim',
        dependencies = {
            {
                'folke/snacks.nvim',
                opts = {
                    terminal = {},
                },
            },
        },
        event = 'LspAttach',
        config = function()
            local codeaction = require('tiny-code-action')

            codeaction.setup({
                picker = {
                    'buffer',
                    opts = {
                        auto_preview = true,
                        hotkeys = true,
                        hotkeys_mode = 'sequential',
                    },
                },
            })

            vim.keymap.set('n', '<leader>.', codeaction.code_action)
        end,
    },
}
