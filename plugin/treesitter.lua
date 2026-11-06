add({
    'nvim-treesitter/nvim-treesitter',
    'neovim-treesitter/treesitter-parser-registry',
    'davidmh/mdx.nvim',
    'windwp/nvim-ts-autotag',
    'andymass/vim-matchup',
})

local treesitter = require('nvim-treesitter')
local parsers = require('extensions').ts_parsers

treesitter.setup({})
treesitter.install(parsers)

-- Enable Treesitter highlighting and indentation
local group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(args)
        -- Only enable for configured languages
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)

        if not lang or not vim.tbl_contains(parsers, lang) then
            return
        end

        -- Highlighting
        local ok = pcall(vim.treesitter.start, args.buf, lang)

        if not ok then
            return
        end

        -- Treesitter indentation
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

require('nvim-ts-autotag').setup({})

vim.g.matchup_matchparen_offscreen = {
    method = 'popup',
    scrolloff = 1,
}
