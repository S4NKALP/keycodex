local lint = require('lint')

-- Filetype to linters mapping
lint.linters_by_ft = {
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
    javascriptreact = { 'eslint_d' },
    typescriptreact = { 'eslint_d' },
    dockerfile = { 'hadolint' },
    vim = { 'vint' },
    markdown = { 'write_good', 'markdownlint' },
    text = { 'write_good' },
    sh = { 'shellcheck' },
    yaml = { 'actionlint' },
}

-- Trigger linting on save and buffer events
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    callback = function()
        local lint = require('lint')

        -- Get the filetype-specific linters
        local ft = vim.bo.filetype
        local linters = lint.linters_by_ft[ft] or {}

        -- Add cspell if it's not already included
        if not vim.tbl_contains(linters, 'cspell') then
            table.insert(linters, 'cspell')
        end

        -- Run them all
        lint.try_lint(linters)
    end,
})

-- Setup mason-nvim-lint to auto-install linters
local auto_install = require('lib.util').get_user_config('auto_install', true)
local installed_linters = require('plugins.list').linter_sources or {}

require('mason-nvim-lint').setup({
    ensure_installed = installed_linters,
    automatic_installation = auto_install,
})
