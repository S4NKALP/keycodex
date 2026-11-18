local treesitter_parsers = {
    'c',
    'markdown',
    'python',
    'java',
    'cpp',
    'bash',
    'lua',
    'make',
    'json',
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
    'regex',
    'latex',
    'tsx',
    'svelte',
    'typst',
    'vue',
}

local lsp_server = {
    'vtsls',
    'html',
    'cssls',
    'tailwindcss',
    'lua_ls',
    'basedpyright',
    'bashls',
    'clangd',
    'rust_analyzer',
    'gopls',
}

local formatter = {
    'clang_format',
    'ruff',
    'stylua',
    'oxfmt',
    'markdown-toc',
    'markdownlint-cli2',
    'gofumpt',
    -- rustfmt is not a Mason package: it ships with the Rust toolchain
    -- (`rustup component add rustfmt`) and conform picks it up from PATH.
}

-- These are nvim-lint linter names; mason-nvim-lint maps them to packages.
local linter = {
    'oxlint',
    'hadolint',
    'write_good',
    'markdownlint-cli2',
    'shellcheck',
    'actionlint',
    'djlint',
    'ruff',
    'codespell',
    'cspell',
    'golangcilint',
}

return {
    ts_parsers = treesitter_parsers,
    lsp_server = lsp_server,
    formatter = formatter,
    linter = linter,
}
