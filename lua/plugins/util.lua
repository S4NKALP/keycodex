return {

    -- better escape
    {
        'max397574/better-escape.nvim',
        config = function()
            require('better_escape').setup({
                mappings = {
                    -- i for insert, other modes are the first letter too
                    i = {
                        -- map kj to exit insert mode
                        k = {
                            j = '<Esc>',
                        },
                        -- map jk and jj  to exit insert mode
                        j = {
                            k = '<Esc>',
                            j = '<Esc>',
                        },
                        -- disable jj
                        j = {
                            j = false,
                        },
                    },
                },
            })
        end,
    },

    -- float terminal
    {
        'akinsho/toggleterm.nvim',
        cmd = { 'ToggleTerm' },
        version = '*',
        config = function()
            require('toggleterm').setup({
                size = 10,
                open_mapping = [[<c-\>]],
                hide_numbers = true,
                shade_filetypes = {},
                shade_terminals = true,
                shading_factor = '2',
                start_in_insert = true,
                insert_mappings = true,
                terminal_mappings = true,
                persist_size = true,
                direction = 'float', -- 'vertical' | 'horizontal' | 'tab' | 'float'
                close_on_exit = true,
                shell = vim.o.shell,
                float_opts = {
                    border = 'curved', --  'single', 'double', 'shadow', etc.
                    winblend = 0, -- Set to 0 for full transparency
                    highlights = {
                        border = 'Normal',
                        background = 'Normal',
                    },
                },
            })
        end,
    },

    -- discord presence
    -- {
    -- 	"vyfor/cord.nvim",
    -- 	event = "VeryLazy",
    -- },

    -- wakatime
    { 'wakatime/vim-wakatime', event = 'VimEnter', lazy = false },

    -- workflow
    {
        'm4xshen/hardtime.nvim',
        lazy = false,
        opts = {},
    },

    -- buffer manager
    {
        'serhez/bento.nvim',
        opts = {},
        -- config = function()
        --     require('bento').setup({
        --         ordering_metric = 'edit',
        --         ui = {
        --             mode = 'floating',
        --             floating = {
        --                 position = 'middle-right',
        --                 minimal_menu = 'full',
        --             },
        --         },
        --     })
        -- end,
    },

    -- navigator
    {
        'numToStr/Navigator.nvim',
        event = 'VeryLazy',
        config = function()
            require('Navigator').setup({
                auto_save = 'current',
                disable_on_zoom = false,
                mux = 'auto',
            })
        end,
    },
}
