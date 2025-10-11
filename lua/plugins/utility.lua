return {
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false },
        ft = {
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
        },
        keys = { { 'gc', mode = { 'n', 'x' } }, { 'gbc', mode = { 'n', 'x' } } },
    },

    --harpoon
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local harpoon = require('harpoon')
            harpoon:setup()

            vim.keymap.set('n', '<leader>ha', function()
                harpoon:list():add()
            end, { desc = 'Harpoon add file' })
            vim.keymap.set('n', '<leader>hl', function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = 'Harpoon quick menu' })

            for i = 1, 9 do
                vim.keymap.set('n', '<A-' .. i .. '>', function()
                    harpoon:list():select(i)
                end, { desc = 'Harpoon to file ' .. i })
            end
        end,
    },

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

    -- Navigator
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
                    winblend = 0,      -- Set to 0 for full transparency
                    highlights = {
                        border = 'Normal',
                        background = 'Normal',
                    },
                },
            })
        end,
    },

    -- smooth scrolling
    {
        'karb94/neoscroll.nvim',
        opts = {},
    },

    -- discord presence
    -- {
    -- 	"vyfor/cord.nvim",
    -- 	event = "VeryLazy",
    -- },

    -- uv
    {
        'benomahony/uv.nvim',
        ft = 'python',
        event = 'BufReadPre',
        opts = {
            picker_integration = true,
            keymaps = {
                prefix = '<leader>u', -- Main prefix for uv commands
                commands = true,      -- Show uv commands menu (<leader>x)
                run_file = true,      -- Run current file (<leader>xr)
                run_selection = true, -- Run selected code (<leader>xs)
                run_function = true,  -- Run function (<leader>xf)
                venv = true,          -- Environment management (<leader>xe)
                init = true,          -- Initialize uv project (<leader>xi)
                add = true,           -- Add a package (<leader>xa)
                remove = true,        -- Remove a package (<leader>xd)
                sync = true,          -- Sync packages (<leader>xc)
                sync_all = true,      -- Sync all packages, extras and groups (<leader>xC)
            },
        },
    },

    { 'wakatime/vim-wakatime', event = 'VimEnter', lazy = false },

    {
        'm4xshen/hardtime.nvim',
        lazy = false,
        opts = {},
    },

    -- file operations
    {
        'chrisgrieser/nvim-genghis',
        keys = {
            {
                '<leader>fn',
                function()
                    require('genghis').createNewFile()
                end,
                desc = 'New File',
            },
            {
                '<leader>fd',
                function()
                    require('genghis').duplicateFile()
                end,
                desc = 'Duplicate File',
            },
            {
                '<leader>fr',
                function()
                    require('genghis').renameFile()
                end,
                desc = 'Rename File',
            },
            {
                '<leader>fx',
                function()
                    require('genghis').chmodx()
                end,
                desc = 'Make Executable',
            },
        },
    },

    -- fold
    {
        'kevinhwang91/nvim-ufo',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'kevinhwang91/promise-async', event = 'BufReadPost' },
        opts = {
            provider_selector = function()
                return { 'lsp', 'indent' }
            end,
            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ('  … %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, 'MoreMsg' })
                return newVirtText
            end,
            open_fold_hl_timeout = 0,
        },
        keys = {
            { 'fd', 'zd', desc = 'Delete fold under cursor' },
            { 'fo', 'zo', desc = 'Open fold under cursor' },
            { 'fO', 'zO', desc = 'Open all folds under cursor' },
            { 'fc', 'zC', desc = 'Close all folds under cursor' },
            { 'fa', 'za', desc = 'Toggle fold under cursor' },
            { 'fA', 'zA', desc = 'Toggle all folds under cursor' },
            { 'fv', 'zv', desc = 'Show cursor line' },
            {
                'fM',
                function()
                    require('ufo').closeAllFolds()
                end,
                desc = 'Close all folds',
            },
            {
                'fR',
                function()
                    require('ufo').openAllFolds()
                end,
                desc = 'Open all folds',
            },
            {
                'fm',
                function()
                    require('ufo').closeFoldsWith()
                end,
                desc = 'Fold more',
            },
            {
                'fr',
                function()
                    require('ufo').openFoldsExceptKinds()
                end,
                desc = 'Fold less',
            },
            { 'fx', 'zx', desc = 'Update folds' },
            { 'fz', 'zz', desc = 'Center this line' },
            { 'ft', 'zt', desc = 'Top this line' },
            { 'fb', 'zb', desc = 'Bottom this line' },
            { 'fg', 'zg', desc = 'Add word to spell list' },
            { 'fw', 'zw', desc = 'Mark word as bad/misspelling' },
            { 'fe', 'ze', desc = 'Right this line' },
            { 'fE', 'zE', desc = 'Delete all folds in current buffer' },
            { 'fs', 'zs', desc = 'Left this line' },
            { 'fH', 'zH', desc = 'Half screen to the left' },
            { 'fL', 'zL', desc = 'Half screen to the right' },
        },
    },
}
