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

map('n', '<leader>r', vim.lsp.buf.rename)
map('n', '`', "'", { noremap = true }) -- better marks

map('n', 'H', '^', { desc = 'Jump to line start' })
map('n', 'L', '$', { desc = 'Jump to line end' })

-- Visual overwrite paste
map({ 'v', 'x' }, 'p', '"_dP', opts)

-- Do not copy on x
map({ 'v', 'x' }, 'x', '"_x', opts)
map('n', 'X', '"_D', opts)
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
map('i', '<C-h>', '<Left>', { desc = 'Move to end of previous line' })
map('i', '<C-j>', '<Down>', { desc = 'Move cursor down' })
map('i', '<C-k>', '<Up>', { desc = 'Move cursor up' })
map('i', '<C-l>', '<Right>', { desc = 'Move cursor right' })

-- toggle inlay hints
vim.keymap.set('n', '<leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- No arrow navigation
vim.api.nvim_set_keymap('n', '<Up>', '<Nop>', opts)
vim.api.nvim_set_keymap('n', '<Down>', '<Nop>', opts)
vim.api.nvim_set_keymap('n', '<Left>', '<Nop>', opts)
vim.api.nvim_set_keymap('n', '<Right>', '<Nop>', opts)

vim.api.nvim_set_keymap('v', '<Up>', '<Nop>', opts)
vim.api.nvim_set_keymap('v', '<Down>', '<Nop>', opts)
vim.api.nvim_set_keymap('v', '<Left>', '<Nop>', opts)
vim.api.nvim_set_keymap('v', '<Right>', '<Nop>', opts)

vim.api.nvim_set_keymap('i', '<Up>', '<Nop>', opts)
vim.api.nvim_set_keymap('i', '<Down>', '<Nop>', opts)
vim.api.nvim_set_keymap('i', '<Left>', '<Nop>', opts)
vim.api.nvim_set_keymap('i', '<Right>', '<Nop>', opts)
