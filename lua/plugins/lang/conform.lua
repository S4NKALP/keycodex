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
        sh = { 'shfmt', 'shellcheck' },
        ['_'] = { 'trim_whitespace', lsp_format = 'prefer' },
    },

    -- Autoformat on save
    format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
    },
})

vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
        vim.notify('Autoformat on save disabled', vim.log.levels.WARN)
    end
end, {
    desc = 'Disable autoformat-on-save',
    bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
    vim.notify('Autoformat on save enabled', vim.log.levels.INFO)
end, {
    desc = 'Re-enable autoformat-on-save',
})

-- Add keymap to disable and enable format on save
vim.keymap.set('n', [[\f]], function()
    if vim.b.disable_autoformat or vim.g.disable_autoformat then
        vim.cmd('FormatEnable')
    else
        vim.cmd('FormatDisable')
    end
end, { desc = 'Toggle auto-format' })

-- Setup mason-conform
local auto_install = require('lib.util').get_user_config('auto_install', true)
local installed_formatters = require('plugins.list').formatter_sources or {}

require('mason-conform').setup({
    ensure_installed = installed_formatters,
    automatic_installation = auto_install,
})
