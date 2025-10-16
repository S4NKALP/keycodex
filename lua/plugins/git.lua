return {
    -- FLOATING COMMIT WINDOW
    {
        'lsig/messenger.nvim',
        enabled = false,
        opts = {
            border = 'rounded',
        },
        keys = {
            {
                '<leader>gc',
                '<Cmd>MessengerShow<CR>',
                desc = 'show commit in floating window',
                mode = 'n',
                noremap = true,
                silent = true,
            },
        },
    },
    -- git signs
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = ' ' },
                    change = { text = '󱗜 ' },
                    delete = { text = '󰍵 ' },
                    topdelete = { text = '󱥨 ' },
                    changedelete = { text = '󰾟 ' },
                    untracked = { text = '󰰧 ' },
                },
                signs_staged = {
                    add = { text = ' ' },
                    change = { text = '󱗜 ' },
                    delete = { text = '󰍵 ' },
                    topdelete = { text = '󱥨 ' },
                    changedelete = { text = '󰾟 ' },
                    untracked = { text = '󰰧 ' },
                },
                signs_staged_enable = true,
                signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
                numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
                linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
                word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    follow_files = true,
                },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                    use_focus = true,
                },
                current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,  -- Use default
                max_file_length = 40000, -- Disable if file is longer than this (in lines)
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1,
                },
            })
        end,
    },

    -- lazygit integration
    {
        'kdheepak/lazygit.nvim',
        lazy = true,
        enabled = true,
        cmd = {
            'LazyGit',
            'LazyGitConfig',
            'LazyGitCurrentFile',
            'LazyGitFilter',
            'LazyGitFilterCurrentFile',
        },
        keys = {
            { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
        },
        config = function()
            vim.g.lazygit_floating_window_winblend = 0
            vim.g.lazygit_floating_window_scaling_factor = 0.9
            vim.g.lazygit_floating_window_border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
        end,
    },
}
