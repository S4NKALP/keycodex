local function augroup(name)
    return vim.api.nvim_create_augroup('nvim_' .. name, { clear = true })
end

-- Yank highlight autocmd (built-in)
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 150 })
    end,
})

-- smart column only when needed
local smart_column_group = vim.api.nvim_create_augroup('SmartColumn', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'BufEnter', 'WinEnter' }, {
    group = smart_column_group,
    callback = function()
        local limit = 120
        local disabled_fts = { 'help', 'text', 'markdown', 'oil', 'snacks_dashboard', 'dashboard', 'keycodex' }

        if vim.tbl_contains(disabled_fts, vim.bo.filetype) then
            vim.wo.colorcolumn = ''
            return
        end

        local curr_line = vim.api.nvim_get_current_line()
        if vim.fn.strdisplaywidth(curr_line) > limit then
            vim.wo.colorcolumn = tostring(limit)
        else
            vim.wo.colorcolumn = ''
        end
    end,
})

-- Secure .env masking
--
-- The values are hidden with extmark conceal, so the buffer always holds the
-- real text: writes, yanks, LSP and other plugins see the file as it is. What
-- is hidden is only what gets drawn on screen, which is privacy for screen
-- sharing and pair programming, not a sandbox.
local env_ns = vim.api.nvim_create_namespace('secure_env')

local function mask_env(buf)
    vim.api.nvim_buf_clear_namespace(buf, env_ns, 0, -1)
    for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
        -- skip comments and anything that is not `KEY=value`
        local eq = line:find('=')
        if eq and not line:match('^%s*#') and line:match('^%s*[%w_.%-]+%s*=') then
            local rest = line:sub(eq + 1)
            -- HIDE="x" keeps the HIDE= part and the closing quote visible
            local skip = #(rest:match('^%s*["\']?') or '')
            local start_col = eq + skip
            local end_col = #(line:gsub('[%s"\']+$', ''))
            if end_col > start_col then
                vim.api.nvim_buf_set_extmark(buf, env_ns, i - 1, start_col, {
                    end_col = end_col,
                    conceal = '*',
                    hl_group = 'Comment',
                })
            end
        end
    end
end

-- Hide or reveal `buf` in every window showing it, and remember the choice on
-- the buffer so a new window does not come up unmasked.
local function apply_env_conceal(buf, hidden)
    vim.b[buf].secure_env_hidden = hidden
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.wo[win].conceallevel = hidden and 2 or 0
        if hidden then
            -- 'nvc': hide the value on the cursor line too, except in insert
            -- mode, where the line you are editing shows the real text.
            vim.wo[win].concealcursor = 'nvc'
        end
    end
    if hidden then
        mask_env(buf)
    else
        vim.api.nvim_buf_clear_namespace(buf, env_ns, 0, -1)
    end
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    group = augroup('secure_env'),
    pattern = { '.env', '.env.*', '*.env' },
    callback = function(args)
        apply_env_conceal(args.buf, true)
        vim.keymap.set('n', '<leader>et', function()
            local hidden = vim.b[args.buf].secure_env_hidden ~= false
            apply_env_conceal(args.buf, not hidden)
            vim.notify('Secrets ' .. (hidden and 'visible' or 'hidden'), vim.log.levels.INFO, { title = '.env' })
        end, { buffer = args.buf, desc = 'Toggle env hiding' })
    end,
})

-- extmarks follow edits, but new lines and window switches need a refresh.
-- TextChanged only fires for Normal mode edits, so Insert mode needs its own
-- events; otherwise a variable typed on a new line stays visible.
vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'TextChangedP', 'InsertLeave', 'BufEnter' }, {
    group = augroup('secure_env_refresh'),
    pattern = { '.env', '.env.*', '*.env' },
    callback = function(args)
        if vim.b[args.buf].secure_env_hidden == false then
            return
        end
        apply_env_conceal(args.buf, true)
    end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd('VimResized', {
    group = augroup('resize_splits'),
    callback = function()
        vim.cmd('tabdo wincmd =')
    end,
})

-- Close specific filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('close_with_q'),
    pattern = {
        'help',
        'lspinfo',
        'man',
        'notify',
        'qf',
        'query',
        'spectre_panel',
        'startuptime',
        'tsplayground',
        'neotest-output',
        'checkhealth',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})

-- Auto-create parent directories on save (`:w new/dir/file.txt` works)
vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup('auto_create_dir'),
    callback = function(event)
        local file = event.match
        -- skip unnamed/special buffers and non-local protocols (oil://, fugitive://, etc.)
        if file == '' or vim.bo[event.buf].buftype ~= '' or file:match('^%a[%w+.-]*://') then
            return
        end
        local dir = vim.fn.fnamemodify(file, ':p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end,
})

-- LSP Attach Features
vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup('lsp_attach_autocmds'),
    callback = function(args)
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        -- Document Highlight. One augroup per buffer, created with `clear`, so a
        -- second client attaching replaces that buffer's autocmds instead of
        -- stacking a duplicate set that highlights twice per cursor hold.
        if client:supports_method('textDocument/documentHighlight') then
            local group = vim.api.nvim_create_augroup('nvim_lsp_highlight_' .. buf, { clear = true })
            vim.api.nvim_create_autocmd('CursorHold', {
                group = group,
                buffer = buf,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                group = group,
                buffer = buf,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- Inlay Hints
        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
        end
    end,
})

-- Drop the per-buffer highlight augroup once no client left can serve it
vim.api.nvim_create_autocmd('LspDetach', {
    group = augroup('lsp_detach_autocmds'),
    callback = function(args)
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
            if client.id ~= args.data.client_id and client:supports_method('textDocument/documentHighlight') then
                return
            end
        end
        pcall(vim.api.nvim_del_augroup_by_name, 'nvim_lsp_highlight_' .. args.buf)
    end,
})

-- Wrap and spellcheck in text filetypes
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('wrap_spell'),
    pattern = { 'gitcommit', 'markdown', 'text' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Disable auto-commenting on new lines
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('no_auto_comment'),
    callback = function()
        vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})

-- Manual Treesitter Installation command
vim.api.nvim_create_user_command('TSInstallAll', function()
    local parsers = require('extensions').ts_parsers
    vim.notify('Installing all configured Tree-sitter parsers...', vim.log.levels.INFO, { title = 'Tree-sitter' })
    require('nvim-treesitter.install').install(parsers)
end, { desc = 'Install all configured Tree-sitter parsers' })

-- Macro Notifications
vim.api.nvim_create_autocmd('RecordingEnter', {
    callback = function()
        vim.notify('Recording macro...', vim.log.levels.INFO, { title = 'Macro', timeout = 1000 })
    end,
})

vim.api.nvim_create_autocmd('RecordingLeave', {
    callback = function()
        local reg = vim.v.recording
        vim.notify('Stopped recording @' .. reg, vim.log.levels.INFO, { title = 'Macro', timeout = 1000 })
    end,
})

-- Disable conform during VimLeavePre to prevent LSP shutdown race
vim.api.nvim_create_autocmd('VimLeavePre', {
    group = augroup('disable_conform_on_exit'),
    pattern = '*',
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            vim.b[buf].conform_disable = true
        end
    end,
})

-- Autoinstall is handled by `vim.pack.add()` in `lua/pack_helper.lua`:
-- plugins missing from disk are installed on the `add()` call, so the extra
-- `vim.pack.get()` scan at VimEnter (measured ~170ms) is not needed.
