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
        version = '*',
        lazy = false,
        config = function()
            require('nvim-tree').setup({
                sort = {
                    sorter = 'case_sensitive',
                },
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
            })
        end,
    },
}
