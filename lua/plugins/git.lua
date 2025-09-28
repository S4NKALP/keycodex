return {

    -- git signs
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = {
                    text = '+',
                },
                change = {
                    text = '▎',
                },
                delete = {
                    text = '',
                },
                topdelete = {
                    text = '▾',
                },
                changedelete = {
                    text = '~',
                },
                untracked = {
                    text = '┆',
                },
            },
            signs_staged = {
                add = {
                    text = '+',
                },
                change = {
                    text = '▎',
                },
                delete = {
                    text = '',
                },
                topdelete = {
                    text = '▾',
                },
                changedelete = {
                    text = '~',
                },
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
