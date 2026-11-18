local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end
local opts = { noremap = true, silent = true }

-- Space as leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Modes
-- normal_mode = "n", insert_mode = "i", visual_mode = "v",
-- visual_block_mode = "x", term_mode = "t", command_mode = "c",

-- Terminal Mappings
map('t', 'jk', '<C-\\><C-n>')
map('t', 'kj', '<C-\\><C-n>')
map('t', '<ESC>', '<C-\\><C-n>')

-- Insert Mode Mappings
map('i', 'jk', '<Esc>')
map('n', '<leader>ps', require('packui').open, { desc = 'Open Vim Pack UI' })
-- Comments
map('n', '<leader>/', 'gcc', { remap = true, desc = 'Toggle comment' })
map('v', '<leader>/', 'gc', { remap = true, desc = 'Toggle comment' })

-- Clear search, diff update and redraw
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

map({ 'i', 'c' }, '<C-b>', '<Left>')
map({ 'i', 'c' }, '<C-f>', '<Right>')

map('n', '`', "'", { noremap = true }) -- better marks

-- Options (which-key only listed these before)
map('n', '<leader>oi', function()
    vim.show_pos()
end, { desc = 'Inspect Position' })
map('n', '<leader>oN', function()
    require('snacks').notifier.show_history()
end, { desc = 'Notification History' })
map('n', '<leader>or', '<cmd>set relativenumber!<cr>', { desc = 'Relative Numbers' })

map({ 'n', 'v' }, 'H', '^', { desc = 'Move to the beginning of the line' })
map({ 'n', 'v' }, 'L', '$', { desc = 'Move to the end of the line' })

-- Select all
map('n', '<leader>a', 'ggVG', { desc = 'Select all' })
map('n', '<C-a>', 'ggVG', { desc = 'Select all' })
map('i', '<C-a>', '<Esc>ggVG', { desc = 'Select all' })

-- Move text up and down
map({ 'v', 'x' }, 'K', ":move '<-2<cr>gv-gv", opts)
map({ 'v', 'x' }, 'J', ":move '>+1<cr>gv-gv", opts)

-- Line operations
map('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
map('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move line up' })
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { desc = 'Move line down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

-- Line manipulation
map('n', '<C-]>', '>>', { desc = 'Indent line' })
map('n', '<C-[>', '<<', { desc = 'Unindent line' })
map('i', '<C-]>', '<C-o>>>', { desc = 'Indent line' })
map('i', '<C-[>', '<C-o><<', { desc = 'Unindent line' })

-- Quick word operations
map('n', '<C-BS>', 'db', { desc = 'Delete word backward' })
map('i', '<C-BS>', '<C-w>', { desc = 'Delete word backward' })
map('n', '<C-Del>', 'dw', { desc = 'Delete word forward' })
map('i', '<C-Del>', '<C-o>dw', { desc = 'Delete word forward' })

-- Deletes and changes go to the black-hole register, so the clipboard survives.
-- No `dd` mapping: `d` followed by the line motion already covers it, and a
-- separate `dd` makes `d` wait for `timeoutlen` as an ambiguous prefix.
for _, key in ipairs({ 'd', 'c', 'x', 'X' }) do
    map({ 'n', 'v' }, key, '"_' .. key, { desc = 'Delete without replacing clipboard' })
end
map('v', 'p', '"_dP', { desc = 'Paste without replacing clipboard' })

-- Paste and reindent to the surrounding indentation level
map('n', 'p', 'p<Cmd>lua require("paste").reindent_put()<cr>', { desc = 'Paste and reindent' })
map('n', 'P', 'P<Cmd>lua require("paste").reindent_put()<cr>', { desc = 'Paste before and reindent' })
map('n', 'gp', 'gp<Cmd>lua require("paste").reindent_put()<cr>', { desc = 'Paste and reindent (cursor after)' })
map('n', 'gP', 'gP<Cmd>lua require("paste").reindent_put()<cr>', { desc = 'Paste before and reindent (cursor after)' })

--insert the following characters around the visual selection
map('v', '<leader>(', 's()<esc>Pll', { desc = 'wrap selection with parens' })
map('v', '<leader>[', 's[]<esc>Pll', { desc = 'wrap selection with square braces' })
map('v', '<leader>{', 's{}<esc>Pll', { desc = 'wrap selection with curly braces' })
map('v', "<leader>'", "s''<esc>Pll", { desc = 'wrap selection with single quotes' })
map('v', '<leader>"', 's""<esc>Pll', { desc = 'wrap selection with double quotes' })

-- Insert mode cursor movement with Ctrl+hjkl
map({ 'i', 'c' }, '<C-h>', '<Left>', { noremap = true, silent = true })
map({ 'i', 'c' }, '<C-j>', '<Down>', { noremap = true, silent = true })
map({ 'i', 'c' }, '<C-k>', '<Up>', { noremap = true, silent = true })
map({ 'i', 'c' }, '<C-l>', '<Right>', { noremap = true, silent = true })

map('n', '<leader>re', ':%s/<C-R><C-W>/', { desc = 'Shortcut to replace current word under cursor' })

-- toggle inlay hints
vim.keymap.set('n', '<leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- No arrow navigation
local modes = { 'n', 'v', 'i' }
local arrows = { '<Up>', '<Down>', '<Left>', '<Right>' }

for _, mode in ipairs(modes) do
    for _, key in ipairs(arrows) do
        vim.api.nvim_set_keymap(mode, key, '<Nop>', opts)
    end
end

-- Go to Beginning or End of line
map({ 'n', 'v' }, 'H', '_^', { desc = 'Move to the beginning of the line' })
map({ 'n', 'v' }, 'L', '$', { desc = 'Move to the end of the line' })

-- Search inside visually highlighted text.
map('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })

-- Search & replace in current file/line
map('v', '<leader>rw', '"9y:%s@<c-r>9@<c-r>9@g<left><left>', { desc = 'Search & replace selection', silent = false })
map('n', '<leader>rw', 'viw"9y:%s@<c-r>9@<c-r>9@g<left><left>', { desc = 'Search & replace word', silent = false })
map(
    'v',
    '<leader>rl',
    '"9y:s@<c-r>9@<c-r>9@g<left><left>',
    { desc = 'Search & replace in current line', silent = false }
)
map(
    'n',
    '<leader>rl',
    'viw"9y:s@<c-r>9@<c-r>9@g<left><left>',
    { desc = 'Search & replace word in current line', silent = false }
)

-- Replace word under cursor, choosing the scope with a snacks picker
local function replace_word()
    local word = vim.fn.expand('<cword>')
    if word == '' then
        vim.notify('No word under cursor', vim.log.levels.WARN)
        return
    end

    local scopes = {
        { text = 'Buffer', detail = 'all occurrences', icon = '󰈔', kind = 'buffer' },
        { text = 'Buffer (confirm each)', detail = 'y/n per match', icon = '󰈔', kind = 'buffer_confirm' },
    }
    if vim.fn.executable('rg') == 1 then
        table.insert(
            scopes,
            { text = 'Project (confirm each)', detail = 'ripgrep + quickfix', icon = '󰉋', kind = 'project' }
        )
    end

    -- Escaped pattern for the word and replacement
    local pat = '\\<' .. vim.fn.escape(word, '\\/.*$^~[]|') .. '\\>'

    require('snacks').picker.select(scopes, {
        prompt = "Replace '" .. word .. "' in",
        format_item = function(item, supports_chunks)
            if supports_chunks then
                return { { item.icon .. ' ', 'SnacksPickerIcon' }, { item.text }, { ' ' .. item.detail, 'Comment' } }
            end
            return item.text
        end,
    }, function(choice)
        if not choice then
            return
        end

        require('snacks').input({ prompt = "Replace '" .. word .. "' with", default = word }, function(new)
            if not new or new == '' or new == word then
                return
            end

            local rep = vim.fn.escape(new, '\\/&~|')
            local sub = ('%%s/%s/%s/'):format(pat, rep)

            if choice.kind == 'buffer' then
                vim.cmd(sub .. 'g')
            elseif choice.kind == 'buffer_confirm' then
                vim.cmd(sub .. 'gc')
            else
                local out = vim.fn.systemlist({
                    'rg',
                    '--vimgrep',
                    '--no-heading',
                    '--color=never',
                    '-w',
                    '-F',
                    '--',
                    word,
                })
                local items = {}
                for _, line in ipairs(out) do
                    local file, lnum, col, text = line:match('^(.-):(%d+):(%d+):(.*)$')
                    if file then
                        items[#items + 1] = {
                            filename = file,
                            lnum = tonumber(lnum),
                            col = tonumber(col),
                            text = text,
                        }
                    end
                end
                if #items == 0 then
                    vim.notify("No matches for '" .. word .. "'", vim.log.levels.WARN)
                    return
                end
                vim.fn.setqflist({}, ' ', { title = "Replace '" .. word .. "'", items = items })
                vim.cmd('cfdo ' .. sub .. 'gce | update')
            end
        end)
    end)
end

map('n', '<leader>R', replace_word, { desc = 'Replace word (choose scope)' })

-- Folds
map('n', '<leader><', function()
    if not vim.opt.foldmethod then
        vim.opt.foldmethod = 'indent'
    end
    vim.cmd('normal! zM')
end, { desc = 'Fold all' })

map('n', '<leader>>', function()
    vim.opt.foldenable = false
    vim.cmd('normal! zR')
end, { desc = 'Open all folds' })

-- Open the file under the cursor, without Vim's E447 when there is no file.
-- Understands `path:line`, and searches buffer dir / cwd as fallbacks.
map('n', '<leader>ef', function()
    -- `<cfile>` strips a trailing `:line`, so start from the WORD and clean it
    local raw = vim.fn.expand('<cWORD>'):gsub('^[%(%[{<"\']+', ''):gsub('[%]%)}>"\',;]+$', '')
    local path, line = raw:match('^(.+):(%d+)$')
    path = path or vim.fn.expand('<cfile>')

    if path == '' then
        vim.notify('No file under cursor', vim.log.levels.WARN, { title = 'File Under Cursor' })
        return
    end

    for _, candidate in ipairs({
        path,
        vim.fn.expand('%:p:h') .. '/' .. path,
        vim.fn.getcwd() .. '/' .. path,
    }) do
        if vim.fn.filereadable(candidate) == 1 then
            vim.cmd.edit(vim.fn.fnameescape(candidate))
            if line and vim.fn.line('$') >= tonumber(line) then
                vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
            end
            return
        end
    end

    vim.notify('No file found for "' .. path .. '"', vim.log.levels.WARN, { title = 'File Under Cursor' })
end, { desc = 'File Under Cursor' })

-- LSP rename (labelled under <leader>r in which-key)
map('n', '<leader>rr', function()
    vim.lsp.buf.rename()
end, { desc = 'Smart Rename' })

-- Copy helpers behind the <leader>y* mappings
local function copy_to_clipboard(text)
    vim.fn.setreg('+', text)
    vim.notify('Copied: ' .. text, vim.log.levels.INFO, { title = 'Yank', timeout = 1000 })
end

local function path_with_line(expr, with_line)
    local path = vim.fn.expand(expr)
    return with_line and ('%s:%d'):format(path, vim.fn.line('.')) or path
end

for name, spec in pairs({
    CopyFileName = { '%:t', false },
    CopyRelativePath = { '%:.', false },
    CopyAbsolutePath = { '%:p', false },
    CopyRelativePathWithLine = { '%:.', true },
    CopyAbsolutePathWithLine = { '%:p', true },
}) do
    vim.api.nvim_create_user_command(name, function()
        copy_to_clipboard(path_with_line(spec[1], spec[2]))
    end, { desc = 'Copy ' .. name })
end
