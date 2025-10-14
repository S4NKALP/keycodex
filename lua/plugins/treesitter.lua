return {
    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('nvim-treesitter').setup({
                ensure_installed = {
                    'c',
                    'markdown',
                    'python',
                    'java',
                    'cpp',
                    'bash',
                    'lua',
                    'make',
                    'latex',
                    'json',
                    'jsonc',
                    'sql',
                    'yaml',
                    'toml',
                    'javascript',
                    'typescript',
                    'gitignore',
                    'go',
                    'rust',
                    'html',
                    'css',
                    'scss',
                    'markdown_inline',
                },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },
}
