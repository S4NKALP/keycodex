local treesitter_parsers = {
    "c",
    "markdown",
    "python",
    "java",
    "cpp",
    "bash",
    "lua",
    "make",
    "json",
    "jsonc",
    "sql",
    "yaml",
    "toml",
    "javascript",
    "typescript",
    "gitignore",
    "go",
    "rust",
    "html",
    "css",
    "scss",
    "markdown_inline",
}

local lsp_server = {
    "ts_ls",
    "html",
    "cssls",
    "tailwindcss",
    "lua_ls",
    "basedpyright",
    "bashls",
    "clangd",
    "rust_analyzer",
}

local formatter = {
    "clang_format",
    "ruff",
    "stylua",
    "prettier",
    "markdown-toc",
    "markdownlint-cli2",
    "biome",
}

local linter = {
    "eslint_d",
    "hadolint",
    "write_good",
    "markdownlint",
    "shellcheck",
    "actionlint",
    "djlint",
    "ruff",
    "codespell",
    "cspell",
}

return {
    ts_parsers = treesitter_parsers,
    lsp_server = lsp_server,
    formatter = formatter,
    linter = linter,
}
