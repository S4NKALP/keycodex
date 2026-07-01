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
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufEnter' }, {
    group = smart_column_group,
    callback = function()
        local limit = 120
        local disabled_fts = { 'help', 'text', 'markdown', 'oil', 'snacks_dashboard', 'dashboard' }

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

-- Secure .env Masking
local env_ns = vim.api.nvim_create_namespace('secure_env')

local function toggle_env(buf)
    local is_mod = vim.bo[buf].modified
    vim.bo[buf].modifiable = true
    if vim.b[buf].env_cache then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.b[buf].env_cache)
        vim.api.nvim_buf_clear_namespace(buf, env_ns, 0, -1)
        vim.b[buf].env_cache = nil
    else
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        vim.b[buf].env_cache = vim.deepcopy(lines)
        for i, l in ipairs(lines) do
            if not l:match('^%s*#') then
                lines[i] = l:gsub('(=%s*["\']?)(.-)(["\']?%s*)$', function(p, v, s)
                    return #v > 0 and (p .. string.rep('*', math.max(#v, 8)) .. s) or l
                end)
            end
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_extmark(
            buf,
            env_ns,
            0,
            0,
            { virt_text = { { '  [Values Hidden]', 'WarningMsg' } }, virt_text_pos = 'eol' }
        )
        vim.bo[buf].modifiable = false
    end
    vim.bo[buf].modified = is_mod
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufWriteCmd' }, {
    group = augroup('secure_env'),
    pattern = { '.env', '.env.*', '*.env' },
    callback = function(args)
        local ev, buf = args.event, args.buf
        if ev == 'BufReadPost' or ev == 'BufNewFile' then
            vim.keymap.set('n', '<leader>et', function()
                toggle_env(buf)
            end, { buffer = buf, desc = 'Toggle env' })
            if not vim.b[buf].env_cache then
                toggle_env(buf)
            end
        elseif ev == 'BufWriteCmd' then
            local file = vim.api.nvim_buf_get_name(buf)
            if file ~= '' then
                local lines = vim.b[buf].env_cache or vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                if pcall(vim.fn.writefile, lines, file) then
                    vim.bo[buf].modified = false
                else
                    vim.notify('Write failed!', vim.log.levels.ERROR)
                end
            end
        end
    end,
})

-- Strip trailing spaces before write
vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup('strip_space'),
    pattern = '*',
    callback = function()
        local save = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(save)
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

-- Auto-create directories on save
vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup('auto_create_dir'),
    callback = function(event)
        if event.match:match('^%w%w+://') then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})

-- LSP Attach Features
vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup('lsp_attach_autocmds'),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Document Highlight
        if client and client:supports_method('textDocument/documentHighlight') then
            vim.api.nvim_create_autocmd({ 'CursorHold' }, {
                buffer = args.buf,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = args.buf,
                callback = vim.lsp.buf.clear_references,
            })
        end

        -- Inlay Hints
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
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

-- Auto-Save on InsertLeave with 3s Debounce
local save_timer = nil

local function clear_timer()
    if save_timer then
        save_timer:stop()
        save_timer = nil
    end
end

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    group = augroup('autosave_cancel'),
    callback = clear_timer,
})

vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
    group = augroup('autosave'),
    callback = function(args)
        clear_timer()
        if vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].modified and vim.bo[args.buf].buftype == '' then
            save_timer = vim.defer_fn(function()
                if vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].modified then
                    vim.api.nvim_buf_call(args.buf, function()
                        vim.cmd('silent! write')
                        vim.notify('Autosaved ' .. vim.fn.expand('%:t'), vim.log.levels.INFO, { title = 'Auto-Save' })
                    end)
                end
            end, 3000)
        end
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

-- Autoinstall missing plugins on startup
vim.api.nvim_create_autocmd('VimEnter', {
    group = augroup('autoinstall'),
    callback = function()
        local ok, items = pcall(vim.pack.get, nil, { info = true })
        if ok then
            local missing = {}
            for _, item in ipairs(items) do
                if not item.path or vim.fn.isdirectory(item.path) == 0 then
                    table.insert(missing, item.spec.name or item.spec.src:match('([^/]+)/*$'))
                end
            end
            if #missing > 0 then
                vim.notify('Installing missing plugins...', vim.log.levels.INFO, { title = 'vim.pack' })
                vim.pack.update(missing, { force = true })
            end
        end
    end,
})
