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


-- Use jj as escape
map('i', 'jj', '<Esc>', opts)
map('i', 'jk', '<Esc>', opts)
map('i', 'kj', '<Esc>', opts)
map('t', 'JJ', '<C-\\><C-n>', opts)

-- Terminal Mappings
map('t', 'jk', '<C-\\><C-n>')
map('t', 'kj', '<C-\\><C-n>')
map('t', '<ESC>', '<C-\\><C-n>')

-- Visual overwrite paste
map({ 'v', 'x' }, 'p', '"_dP', opts)

-- Do not copy on x
map({ 'v', 'x' }, 'x', '"_x', opts)

-- VSCode style shortcuts
-- File operations
map('n', '<C-s>', ':w<CR>', { desc = 'Save file' })
map('i', '<C-s>', '<Esc>:w<CR>a', { desc = 'Save file' })
map('n', '<C-q>', ':q<CR>', { desc = 'Quit' })
map('n', '<C-w>', ':bd<CR>', { desc = 'Close buffer' })

-- Undo/Redo
map('n', '<C-z>', 'u', { desc = 'Undo' })
map('i', '<C-z>', '<C-o>u', { desc = 'Undo' })
map('n', '<C-y>', '<C-r>', { desc = 'Redo' })
map('i', '<C-y>', '<C-o><C-r>', { desc = 'Redo' })

-- Select all
map('n', '<C-a>', 'ggVG', { desc = 'Select all' })
map('i', '<C-a>', '<Esc>ggVG', { desc = 'Select all' })

-- Copy/Cut
map('v', '<C-c>', 'y', { desc = 'Copy' })
map('v', '<C-x>', 'd', { desc = 'Cut' })

-- Line operations (VSCode style)
map('n', '<A-Up>', ':m .-2<CR>==', { desc = 'Move line up' })
map('n', '<A-Down>', ':m .+1<CR>==', { desc = 'Move line down' })
map('i', '<A-Up>', '<Esc>:m .-2<CR>==gi', { desc = 'Move line up' })
map('i', '<A-Down>', '<Esc>:m .+1<CR>==gi', { desc = 'Move line down' })
map('v', '<A-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('v', '<A-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })

-- VSCode-style line operations
map('n', '<S-CR>', 'o<Esc>', { desc = 'Insert line below' })
map('i', '<S-CR>', '<C-o>o', { desc = 'Insert line below' })

-- Quick word operations
map('n', '<C-BS>', 'db', { desc = 'Delete word backward' })
map('i', '<C-BS>', '<C-w>', { desc = 'Delete word backward' })
map('n', '<C-Del>', 'dw', { desc = 'Delete word forward' })
map('i', '<C-Del>', '<C-o>dw', { desc = 'Delete word forward' })

-- Duplicate line
map('n', '<A-S-Up>', 'yykP', { desc = 'Duplicate line up' })
map('n', '<A-S-Down>', 'yyp', { desc = 'Duplicate line down' })
map('v', '<A-S-Up>', "y'<Pgv", { desc = 'Duplicate selection up' })
map('v', '<A-S-Down>', "y'>pgv", { desc = 'Duplicate selection down' })


-- Line manipulation
map('n', '<C-]>', '>>', { desc = 'Indent line' })
map('n', '<C-[>', '<<', { desc = 'Unindent line' })
map('i', '<C-]>', '<C-o>>>', { desc = 'Indent line' })
map('i', '<C-[>', '<C-o><<', { desc = 'Unindent line' })

-- Visual overwrite paste
map({ 'v', 'x' }, 'p', '"_dP', opts)

-- Do not copy on x
map({ 'v', 'x' }, 'x', '"_x', opts)
map('n', 'X', '"_D', opts)
map({ 'v', 'x' }, 'X', '"_d', opts)

-- Increment/decrement
map({ 'n', 'v', 'x' }, '-', '<C-x>', opts)
map({ 'n', 'v', 'x' }, '=', '<C-a>', opts)

-- Move to line beginning and end
map({ 'n', 'v', 'x' }, 'gl', '$', { desc = 'End of line' })
map({ 'n', 'v', 'x' }, 'gh', '^', { desc = 'Beginning of line' })

-- Center Cursors
map('n', 'J', 'mzJ`z', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- Better up/down
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move text up and down
map({ 'v', 'x' }, 'J', ":move '>+1<cr>gv-gv", opts)
map({ 'v', 'x' }, 'K', ":move '<-2<cr>gv-gv", opts)

-- Clear search, diff update and redraw
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Consistent n/N search navigation
map('n', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('n', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- Better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Add undo breakpoints
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

map('n', 'd', '"_d', { desc = 'Delete without replacing clipboard' })
map('n', 'x', '"_x', { desc = 'Cut without replacing clipboard' })
map('n', 'c', '"_c', { desc = 'Change without replacing clipboard' })
map('v', 'p', '"_dP', { desc = 'Paste without replacing clipboard' })

-- Toggle relative numbers off or on (for code presentation)
map({ 'n', 'v' }, '<leader>tn', '<cmd>set rnu!<cr>', {})

--insert the following characters around the visual selection
map('v', '<leader>(', 's()<esc>Pll', { desc = 'wrap selection with parens' })
map('v', '<leader>[', 's[]<esc>Pll', { desc = 'wrap selection with square braces' })
map('v', '<leader>{', 's{}<esc>Pll', { desc = 'wrap selection with curly braces' })
map('v', "<leader>'", "s''<esc>Pll", { desc = 'wrap selection with single quotes' })
map('v', '<leader>"', 's""<esc>Pll', { desc = 'wrap selection with double quotes' })

-- Insert mode cursor movement with Ctrl+hjkl
map('i', '<C-h>', '<Left>', { desc = 'Move cursor left' })
map('i', '<C-j>', '<Down>', { desc = 'Move cursor down' })
map('i', '<C-k>', '<Up>', { desc = 'Move cursor up' })
map('i', '<C-l>', '<Right>', { desc = 'Move cursor right' })



