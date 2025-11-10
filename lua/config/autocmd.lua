local function augroup(name)
    return vim.api.nvim_create_augroup('nvim' .. name, { clear = true })
end

-- Strip trailing spaces before write
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = augroup('strip_space'),
    pattern = { '*' },
    callback = function()
        vim.cmd([[ %s/\s\+$//e ]])
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = augroup('checktime'),
    command = 'checktime',
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup('highlight_yank'),
    callback = function()
        vim.highlight.on_yank({ timeout = 200, visual = true })
    end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
    group = augroup('resize_splits'),
    callback = function()
        vim.cmd('tabdo wincmd =')
    end,
})

-- go to last loc when opening a buffer
-- vim.api.nvim_create_autocmd('BufReadPost', {
--     group = augroup('last_loc'),
--     callback = function()
--         local mark = vim.api.nvim_buf_get_mark(0, '"')
--         local lcount = vim.api.nvim_buf_line_count(0)
--         if mark[1] > 0 and mark[1] <= lcount then
--             pcall(vim.api.nvim_win_set_cursor, 0, mark)
--         end
--     end,
-- })

-- restore cursor to file position in previous editing session
-- vim.api.nvim_create_autocmd('BufReadPost', {
--     callback = function(args)
--         local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
--         local line_count = vim.api.nvim_buf_line_count(args.buf)
--         if mark[1] > 0 and mark[1] <= line_count then
--             vim.api.nvim_win_set_cursor(0, mark)
--             -- defer centering slightly so it's applied after render
--             vim.schedule(function()
--                 vim.cmd('normal! zz')
--             end)
--         end
--     end,
-- })

-- open help in vertical split
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'help',
    command = 'wincmd L',
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('no_auto_comment', {}),
    callback = function()
        vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
    group = 'active_cursorline',
    callback = function()
        vim.opt_local.cursorline = false
    end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd('CursorMoved', {
    group = vim.api.nvim_create_augroup('LspReferenceHighlight', { clear = true }),
    desc = 'Highlight references under cursor',
    callback = function()
        -- Only run if the cursor is not in insert mode
        if vim.fn.mode() ~= 'i' then
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            local supports_highlight = false
            for _, client in ipairs(clients) do
                if client.server_capabilities.documentHighlightProvider then
                    supports_highlight = true
                    break -- Found a supporting client, no need to check others
                end
            end

            -- 3. Proceed only if an LSP is active AND supports the feature
            if supports_highlight then
                vim.lsp.buf.clear_references()
                vim.lsp.buf.document_highlight()
            end
        end
    end,
})

-- ide like highlight when stopping cursor
vim.api.nvim_create_autocmd('CursorMovedI', {
    group = 'LspReferenceHighlight',
    desc = 'Clear highlights when entering insert mode',
    callback = function()
        vim.lsp.buf.clear_references()
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('close_with_q'),
    pattern = {
        'Jaq',
        'PlenaryTestPopup',
        'Avante',
        'AvanteInput',
        'AvanteSelectedFiles',
        'fugitive',
        'git',
        'help',
        'lir',
        'lspinfo',
        'man',
        'netrw',
        'notify',
        'qf',
        'spectre_panel',
        'startuptime',
        'tsplayground',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('wrap_spell'),
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = augroup('auto_create_dir'),
    callback = function(event)
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})

-- Set arb filetype
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = augroup('set_file_type'),
    pattern = { '*.arb' },
    command = 'setfiletype arb',
})

-- Disable format options
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('disable_formatoptions'),
    pattern = '*',
    callback = function()
        vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end,
})

local function enable_autoformat()
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
        group = augroup('autoformat'),
        pattern = { '*' },
        callback = function()
            vim.lsp.buf.format()
        end,
    })
end

enable_autoformat()

vim.api.nvim_create_user_command('WriteNoFormat', function()
    -- Temporarily disable the autoformat autocmd
    vim.api.nvim_del_augroup_by_name('keycodex_autoformat')
    vim.cmd('write')
    -- Re-enable the autoformat autocmd
    enable_autoformat()
end, {})

-- Macro recording notifications
vim.api.nvim_create_autocmd('RecordingEnter', {
    callback = function()
        vim.notify('Macro recording started', vim.log.levels.INFO, {
            title = 'Macro',
            timeout = 2000,
        })
        -- Print to command line for debugging
        vim.cmd("echo 'Recording macro...'")
    end,
})

vim.api.nvim_create_autocmd('RecordingLeave', {
    callback = function()
        vim.notify('Macro recording stopped', vim.log.levels.INFO, {
            title = 'Macro',
            timeout = 2000,
        })
        -- Print to command line for debugging
        vim.cmd("echo 'Macro recording stopped'")
    end,
})

-- Function to show macro replay notification
local function show_macro_replay(count)
    local message = count > 1 and string.format('Replaying macro %d times', count) or 'Replaying macro'
    vim.notify(message, vim.log.levels.INFO, {
        title = 'Macro',
        timeout = 2000,
    })
end

-- Function to clear all macros
local function clear_all_macros()
    -- Clear all registers from a to z
    for i = 97, 122 do -- ASCII values for 'a' to 'z'
        vim.fn.setreg(string.char(i), '')
    end
    -- Clear all registers from 0 to 9
    for i = 48, 57 do -- ASCII values for '0' to '9'
        vim.fn.setreg(string.char(i), '')
    end
    vim.notify('All macros cleared', vim.log.levels.INFO, {
        title = 'Macro',
        timeout = 2000,
    })
end

-- Create keymaps for macro replay with notifications
vim.keymap.set('n', '@', function()
    local count = vim.v.count1
    show_macro_replay(count)
    return '@'
end, { expr = true })

-- Add keybinding to clear all macros
vim.keymap.set('n', '<leader>oc', clear_all_macros, { desc = 'Clear all macros' })
