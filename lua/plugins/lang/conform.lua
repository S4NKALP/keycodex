local conform = require('conform')

-- Setup formatters
conform.setup({
    formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        markdown = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        sh = { 'shfmt' },
    },

    -- Autoformat on save
    format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
    },
})

-- Setup mason-conform
local auto_install = require('lib.util').get_user_config('auto_install', true)
local installed_formatters = require('plugins.list').formatter_sources or {}

require('mason-conform').setup({
    ensure_installed = installed_formatters,
    automatic_installation = auto_install,
})
