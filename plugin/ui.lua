add({
    'ellisonleao/gruvbox.nvim',
    'OXY2DEV/markview.nvim', -- rendering for html and markdown
    'brenoprata10/nvim-highlight-colors', -- color highlighting
    { src = 'nvzone/showkeys', cmd = 'ShowkeysToggle' },
})

require('nvim-highlight-colors').setup({ render = 'background' })
require('showkeys').setup({})

local palette = require('gruvbox').palette
require('gruvbox').setup({
    bold = false,
    italic = {
        strings = false,
        emphasis = false,
        comments = false,
        folds = false,
    },
    contrast = 'hard',
    transparent_mode = true,
    overrides = {
        -- builtin
        SignColumn = { bg = 'None' },
        CursorLineNr = { bg = 'None' },
        Whitespace = { fg = palette.dark0 },
        EndOfBuffer = { fg = palette.dark0_hard },
        Visual = { fg = 'None', bg = palette.dark1 },
        Label = { link = 'GruvboxPurple' },

        -- blink.cmp
        BlinkCmpMenu = { link = 'Normal' },
        BlinkCmpMenuBorder = { link = 'BlinkCmpMenu' },
        BlinkCmpMenuSelection = { fg = 'None', bg = palette.dark1 },
        BlinkCmpLabelMatch = { fg = palette.bright_green },
        BlinkCmpScrollBarGutter = { bg = palette.dark2 },
        BlinkCmpScrollBarThumb = { bg = palette.light1 },

        -- indent guides
        MiniIndentscopeSymbol = { fg = palette.dark1 },
    },
})

vim.cmd.colorscheme('gruvbox')

require('markview').setup({
    preview = {
        icon_provider = 'mini',
        enable = false,
    },
})
vim.keymap.set('n', '<leader>cv', '<cmd>Markview toggle<cr>', { desc = 'toggle markdown preview' })
