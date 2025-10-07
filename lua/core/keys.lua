local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end
local opts = { noremap = true, silent = true }

-- Space as leader
map('n', '<Space>', '', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Modes
-- normal_mode = "n", insert_mode = "i", visual_mode = "v",
-- visual_block_mode = "x", term_mode = "t", command_mode = "c",

-- Terminal Mappings
map('t', 'jk', '<C-\\><C-n>')
map('t', 'kj', '<C-\\><C-n>')
map('t', '<ESC>', '<C-\\><C-n>')

-- Clear search, diff update and redraw
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

map({ 'i', 'c' }, '<C-b>', '<Left>')
map({ 'i', 'c' }, '<C-f>', '<Right>')

map('n', '<leader>rL', vim.lsp.buf.rename, { desc = 'Rename Lsp Symbol' })
map('n', '`', "'", { noremap = true }) -- better marks

map({ 'n', 'v' }, 'H', '^', { desc = 'Move to the beginning of the line' })
map({ 'n', 'v' }, 'L', '$', { desc = 'Move to the end of the line' })

-- Visual overwrite paste
map({ 'v', 'x' }, 'p', '"_dP', opts)

-- Do not copy on x
map({ 'v', 'x' }, 'x', '"_x', opts)
map('n', 'X', '"_D', opts)
map('n', 'dd', '"_dd', opts)
map({ 'v', 'x' }, 'X', '"_d', opts)

-- Select all
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

map('n', 'd', '"_d', { desc = 'Delete without replacing clipboard' })
map('n', 'x', '"_x', { desc = 'Cut without replacing clipboard' })
map('n', 'c', '"_c', { desc = 'Change without replacing clipboard' })
map('v', 'p', '"_dP', { desc = 'Paste without replacing clipboard' })

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
