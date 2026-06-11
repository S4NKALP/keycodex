add({
    'OXY2DEV/markview.nvim', -- rendering for html and markdown
    'serhez/bento.nvim', -- buffer manager
    'akinsho/toggleterm.nvim', --float terminal
    'nvzone/showkeys', -- show keystrokes
})
require('bento').setup({})

-- lazy load markdown preview
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        require('markview').setup({
            preview = {
                icon_provider = 'mini',
                enable = false,
            },
        })
    end,
})
vim.keymap.set('n', '<leader>cv', '<cmd>Markview toggle<cr>', { desc = 'toggle markdown preview' })

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
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
            border = 'Normal',
            background = 'Normal',
        },
    },
})

-- showkeys
require('showkeys').setup({
    position = 'top-right',
    show_count = true,
    winopts = {
        focusable = false,
        relative = 'editor',
        style = 'minimal',
        border = 'single',
        height = 1,
        row = 1,
        col = 0,
    },
})

vim.keymap.set('n', '<leader>ok', '<cmd>ShowkeysToggle<CR>', {
    desc = 'Toggle Showkeys',
})
