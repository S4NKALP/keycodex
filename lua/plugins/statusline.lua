return {
    {
        'sschleemilch/slimline.nvim',
        opts = {
            style = 'bg',
            bold = true,
            spaces = {
                components = '',
                left = '',
                right = '',
            },
            sep = {
                hide = {
                    first = true,
                    last = true,
                },
                left = '',
                right = '',
            },
        },
    },
    {
        'akinsho/bufferline.nvim',
        opts = {
            options = {
                show_close_icon = false,
                show_buffer_close_icons = false,
            },
        },
        vim.api.nvim_set_hl(0, 'BufferLineFill', { bg = 'None' }),
    },
}
