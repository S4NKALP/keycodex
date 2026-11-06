add({
    { src = 'iamcco/markdown-preview.nvim', build = 'cd app && npm install' },
    'wakatime/vim-wakatime', --wakaTime coding time tracker
    'szw/vim-maximizer',
    'Exafunction/windsurf.vim', -- windsurf ai for autocompletion
    'akinsho/toggleterm.nvim', --float terminal
    'lambdalisue/suda.vim', -- edit files as sudo (:SudaWrite)
})

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

-- windsurf
vim.keymap.set('i', '<A-f>', function()
    return vim.fn['codeium#Accept']()
end, { expr = true, silent = true })
vim.keymap.set('i', '<A-x>', function()
    return vim.fn['codeium#Clear']()
end, { expr = true, silent = true })
