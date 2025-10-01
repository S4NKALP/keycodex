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
            require('nvim-tree').setup({
                filters = { dotfiles = false },
                disable_netrw = true,
                hijack_cursor = true,
                sync_root_with_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = false,
                },
                view = {
                    width = 30,
                    side = 'right',
                    preserve_window_proportions = true,
                },
                git = {
                    enable = false,
                    ignore = true,
                },
                renderer = {
                    root_folder_label = false,
                    indent_markers = { enable = true },
                    icons = {
                        glyphs = {
                            default = '󰈚',
                            folder = {
                                default = '',
                                empty = '',
                                empty_open = '',
                                open = '',
                                symlink = '',
                            },
                        },
                    },
                },
            })
        end,
        vim.keymap.set('n', '<leader>eo', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' }),
    },
}
