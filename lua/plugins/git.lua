return {
    -- gitignore generator
    {
        'wintermute-cell/gitignore.nvim',
        cmd = { 'Gitignore' },
        opts = {},
    },

    -- git signs
    {
        'lewis6991/gitsigns.nvim',
        events = { 'BufReadPost', 'BufNewFile' },
        opts = {
            signcolumn = true,
            current_line_blame = true,
            attach_to_untracked = false,
            current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
            watch_gitdir = {
                follow_files = true,
            },
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
                use_focus = true,
            },
            signs = {
                add = { text = ' ' },
                change = { text = '󱗜 ' },
                delete = { text = '󰍵 ' },
                topdelete = { text = '󱥨 ' },
                changedelete = { text = '󰾟 ' },
                untracked = { text = '󰰧 ' },
            },
        },
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
