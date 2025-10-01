return {
    {
        'echasnovski/mini.files',
        version = '*',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('mini.files').setup({
                content = {
                    filter = nil,
                    prefix = nil,
                    sort = nil,
                },
                mappings = {
                    close = 'q',
                    go_in = 'L',
                    go_in_plus = 'l',
                    go_out = 'h',
                    go_out_plus = 'H',
                    mark_goto = "'",
                    mark_set = 'm',
                    reset = '<BS>',
                    reveal_cwd = '@',
                    show_help = 'g?',
                    synchronize = '<CR>',
                    trim_left = '<',
                    trim_right = '>',
                },
                options = {
                    permanent_delete = true,
                    use_as_default_explorer = true,
                },
                windows = {
                    max_number = math.huge,
                    preview = false,
                    width_focus = 30,
                    width_nofocus = 20,
                    width_preview = 80,
                },
            })
        end,
    },
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            local nvimtree = require('nvim-tree')

            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            nvimtree.setup({
                view = {
                    width = 30,
                    relativenumber = true,
                    side = 'right',
                },
                sync_root_with_cwd = true,
                renderer = {
                    indent_markers = {
                        enable = true,
                    },
                    icons = {
                        glyphs = {
                            folder = {
                                arrow_closed = '›',
                                arrow_open = '⌄',
                            },
                            git = {
                                staged = 'A',
                                unstaged = 'M',
                                unmerged = '!',
                                renamed = 'R',
                                untracked = 'U',
                                deleted = 'D',
                                ignored = '◌',
                            },
                        },
                    },
                },
                actions = {
                    open_file = {
                        window_picker = {
                            enable = false,
                        },
                    },
                },
                filters = {
                    dotfiles = true,
                    custom = { '.DS_Store' },
                },
                git = {
                    ignore = false,
                },
            })

            vim.keymap.set('n', '<leader>eo', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
        end,
    },
}
