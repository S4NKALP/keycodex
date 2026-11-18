add({
    'mfussenegger/nvim-lint', -- linter
    'rshkarin/mason-nvim-lint', -- linter installer
    'stevearc/conform.nvim', -- autoformater
    'zapling/mason-conform.nvim', -- formatter installer
    'folke/todo-comments.nvim', -- todo comment highlights
    'rachartier/tiny-inline-diagnostic.nvim', -- inline diagnostic
    'rachartier/tiny-code-action.nvim', -- code action
})

require('todo-comments').setup({ signs = false })

-- Run linters on save and after leaving insert mode
vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('nvim_lint', { clear = true }),
    callback = function()
        require('lint').try_lint()
    end,
})

require('lint').linters_by_ft = {
    ['*'] = { 'codespell' },
    ['javascript'] = { 'eslint_d', 'cspell' },
    ['typescript'] = { 'eslint_d', 'cspell' },
    ['javascriptreact'] = { 'eslint_d', 'cspell' },
    ['typescriptreact'] = { 'eslint_d', 'cspell' },
    ['dockerfile'] = { 'hadolint' },
    ['markdown'] = { 'write_good', 'markdownlint' },
    ['text'] = { 'write_good' },
    ['sh'] = { 'shellcheck' },
    ['yaml'] = { 'actionlint' },
    ['python'] = { 'ruff' },
    -- ['go'] = { 'gofmt' },
}

require('tiny-code-action').setup({
    picker = {
        'buffer',
        opts = {
            auto_preview = true,
            hotkeys = true,
            hotkeys_mode = 'sequential',
        },
    },
})

require('tiny-inline-diagnostic').setup({
    options = {
        show_source = true,
        multiple_diag_under_cursor = true,
    },
})

require('mason-nvim-lint').setup({
    ensure_installed = require('extensions').linter,
    automatic_installation = false,
})

require('conform').setup({
    formatters = {
        ['markdown-toc'] = {
            condition = function(_, ctx)
                for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                    if line:find('<!%-%-% toc %-%->') then
                        return true
                    end
                end
            end,
        },
    },
    formatters_by_ft = {
        ['lua'] = { 'stylua' },
        ['c'] = { 'clang_format' },
        ['cpp'] = { 'clang_format' },
        ['h'] = { 'clang_format' },
        ['python'] = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
        ['javascript'] = { 'biome' },
        ['typescript'] = { 'biome' },
        ['typescriptreact'] = { 'biome' },
        ['markdown'] = { 'prettier', 'markdownlint-cli2' },
        ['mdx'] = { 'prettier' },
        ['_'] = { 'trim_whitespace' },
    },
    options = {
        stop_after_first = false,
    },
    format_after_save = function(bufnr)
        if not vim.b[bufnr].conform_disable then
            return {
                lsp_format = 'fallback',
            }
        end
    end,
})

vim.keymap.set('n', '<leader>tf', function()
    vim.b.conform_disable = not vim.b.conform_disable
    local status = vim.b.conform_disable and 'disabled' or 'enabled'
    vim.notify('Autoformat ' .. status, vim.log.levels.INFO)
end, { desc = 'Toggle autoformat' })

vim.api.nvim_create_user_command('WriteNoFormat', function()
    local prev = vim.b.conform_disable
    vim.b.conform_disable = true
    vim.cmd('write')
    vim.b.conform_disable = prev
end, { desc = 'Write without formatting' })

require('mason-conform').setup({
    ensure_installed = require('extensions').formatter,
    automatic_installation = true,
})

vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
vim.keymap.set('n', '<leader>.', function()
    require('tiny-code-action').code_action()
end, { desc = 'Code action' })
