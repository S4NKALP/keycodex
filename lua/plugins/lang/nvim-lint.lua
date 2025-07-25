local lint = require('lint')

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

local function run_lint(bufnr)
    bufnr = bufnr or 0
    local ft = vim.bo[bufnr].filetype

    local linters = vim.list_extend({ 'codespell', 'editorconfig-checker' }, require('lint')._resolve_linter_by_ft(ft))

    local ctx = { filename = vim.api.nvim_buf_get_name(bufnr) }
    ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')

    linters = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        return vim.fn.executable(linter.cmd) == 1
            and not (type(linter) == 'table' and linter.condition and not linter.condition(ctx))
    end, linters)

    if #linters > 0 then
        lint.try_lint(linters)
    end
end

local timer = assert(vim.uv.new_timer())
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
    callback = function(args)
        timer:start(100, 0, function()
            timer:stop()
            vim.schedule(function()
                run_lint(args.buf)
            end)
        end)
    end,
    desc = 'Lint (nvim-lint)',
})

-- Setup mason-nvim-lint to auto-install linters
local auto_install = require('lib.util').get_user_config('auto_install', true)
local installed_linters = require('plugins.list').linter_sources or {}

require('mason-nvim-lint').setup({
    ensure_installed = installed_linters,
    automatic_installation = auto_install,
})
