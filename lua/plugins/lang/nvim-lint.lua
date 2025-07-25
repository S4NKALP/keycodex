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

-- Generic lint function with global linters
local function lint_buffer(bufnr)
    local ft = vim.bo[bufnr or 0].filetype
    local linters = vim.list_extend(
        { 'codespell', 'editorconfig-checker' }, -- global linters
        require('lint')._resolve_linter_by_ft(ft) or {}
    )

    local ctx = {
        filename = vim.api.nvim_buf_get_name(bufnr or 0),
    }
    ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')

    -- Filter linters by executable availability
    linters = vim.tbl_filter(function(name)
        local linter = require('lint').linters[name]
        return linter and vim.fn.executable(linter.cmd) == 1 and (not linter.condition or linter.condition(ctx))
    end, linters)

    if #linters > 0 then
        require('lint').try_lint(linters)
    end
end

-- Create one reusable timer
local uv = vim.loop
local timer = uv.new_timer()

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
    callback = function(args)
        timer:stop()
        timer:start(100, 0, function()
            vim.schedule(function()
                lint_buffer(args.buf)
            end)
        end)
    end,
    desc = 'Lint buffer with custom linters',
})

-- Setup mason-nvim-lint to auto-install linters
local auto_install = require('lib.util').get_user_config('auto_install', true)
local installed_linters = require('plugins.list').linter_sources or {}

require('mason-nvim-lint').setup({
    ensure_installed = installed_linters,
    automatic_installation = auto_install,
})
