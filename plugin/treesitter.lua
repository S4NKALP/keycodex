add({
    'nvim-treesitter/nvim-treesitter', -- nvim-treesitter
    'davidmh/mdx.nvim', -- syntax highlighter for mdx
    'windwp/nvim-ts-autotag', -- autotag
})

require('nvim-ts-autotag').setup({})
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
