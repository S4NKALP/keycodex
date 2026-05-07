add({
    'windwp/nvim-autopairs', -- autopairs
    'windwp/nvim-ts-autotag', -- autotag
    'folke/todo-comments.nvim', -- todo comment highlights
    'wakatime/vim-wakatime', --wakaTime coding time tracker
    'lambdalisue/suda.vim', -- edit files as sudo (:SudaWrite)
    'numToStr/Comment.nvim', -- smart comment toggling
    'NMAC427/guess-indent.nvim', -- auto-detect tab/space indentation
    'brenoprata10/nvim-highlight-colors', -- color highlighting
    'davidmh/mdx.nvim', -- syntax highlighter for mdx
    'nvim-treesitter/nvim-treesitter', -- nvim-treesitter
    'Exafunction/windsurf.vim', -- windsurf ai for autocompletion
    'numToStr/Navigator.nvim', -- navigator
    'm4xshen/hardtime.nvim', -- workflow
    'lukas-reineke/indent-blankline.nvim', --indent guides
    'mg979/vim-visual-multi', -- multiple cursors
})

vim.g.VM_maps = {
    ['Find Under'] = '<M-d>', -- Alt + d | Select word under cursor and start multi-cursor
    ['Find Subword Under'] = '<M-d>', -- Alt + d | Select subword under cursor
    ['Select All'] = '<C-M-d>', -- Ctrl + Alt + d | Select all occurrences in the buffer
    ['Add Cursor Down'] = '<C-M-j>', -- Ctrl + Alt + j | Add a cursor on the line below
    ['Add Cursor Up'] = '<C-M-k>', -- Ctrl + Alt + k | Add a cursor on the line above
}

-- lazy load insert mode enhancements
vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
        require('nvim-autopairs').setup({})
        require('nvim-ts-autotag').setup({})
    end,
    once = true,
})

-- lazy load general editor enhancements
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    callback = function()
        require('todo-comments').setup({ signs = false })
        require('Comment').setup()
        require('guess-indent').setup({})
        require('nvim-highlight-colors').setup({ render = 'background' })
        require('Navigator').setup({
            auto_save = 'current',
            disable_on_zoom = false,
            mux = 'auto',
        })
    end,
})

require('hardtime').setup({})
require('ibl').setup({})

require('nvim-treesitter').setup({
    ensure_installed = require('extensions').ts_parsers,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    indent = {
        enable = true,
    },
})

-- windsurf
vim.keymap.set('i', '<A-f>', function()
    return vim.fn['codeium#Accept']()
end, { expr = true, silent = true })
vim.keymap.set('i', '<A-x>', function()
    return vim.fn['codeium#Clear']()
end, { expr = true, silent = true })
