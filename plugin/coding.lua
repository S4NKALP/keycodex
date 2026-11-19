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

-- Linters are external processes, and InsertLeave is often followed by a
-- BufWritePost for the same buffer, so debounce them per buffer and skip the
-- buffer entirely when its text has not changed since the last run.
local lint_group = vim.api.nvim_create_augroup('nvim_lint', { clear = true })
local lint_timers = {}

local function lint_buffer(buf)
    local tick = vim.api.nvim_buf_get_changedtick(buf)
    if vim.b[buf].lint_tick == tick then
        return
    end
    vim.b[buf].lint_tick = tick
    vim.api.nvim_buf_call(buf, function()
        require('lint').try_lint()
    end)
end

vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
    group = lint_group,
    callback = function(args)
        local buf = args.buf
        local timer = lint_timers[buf]
        if not timer then
            timer = vim.uv.new_timer()
            lint_timers[buf] = timer
        end
        timer:stop()
        timer:start(
            300,
            0,
            vim.schedule_wrap(function()
                if vim.api.nvim_buf_is_valid(buf) then
                    lint_buffer(buf)
                end
            end)
        )
    end,
})

vim.api.nvim_create_autocmd('BufDelete', {
    group = lint_group,
    callback = function(args)
        local timer = lint_timers[args.buf]
        if timer then
            timer:stop()
            timer:close()
            lint_timers[args.buf] = nil
        end
    end,
})

require('lint').linters_by_ft = {
    ['*'] = { 'codespell' },
    ['javascript'] = { 'oxlint', 'cspell' },
    ['typescript'] = { 'oxlint', 'cspell' },
    ['javascriptreact'] = { 'oxlint', 'cspell' },
    ['typescriptreact'] = { 'oxlint', 'cspell' },
    ['dockerfile'] = { 'hadolint' },
    ['markdown'] = { 'write_good', 'markdownlint-cli2' },
    ['text'] = { 'write_good' },
    ['sh'] = { 'shellcheck' },
    ['yaml.ghaction'] = { 'actionlint' },
    ['python'] = { 'ruff' },
    ['go'] = { 'golangcilint' },
    ['htmldjango'] = { 'djlint' },
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
        ['go'] = { 'gofumpt' },
        ['rust'] = { 'rustfmt' },
        ['python'] = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
        ['javascript'] = { 'oxfmt' },
        ['javascriptreact'] = { 'oxfmt' },
        ['typescript'] = { 'oxfmt' },
        ['typescriptreact'] = { 'oxfmt' },
        ['markdown'] = { 'markdownlint-cli2' },
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
