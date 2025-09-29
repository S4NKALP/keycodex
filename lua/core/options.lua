local options = {
    ai = true,
    clipboard = 'unnamedplus', -- use system clipboard
    number = true,
    relativenumber = true,
    undofile = true, -- save state of file on write
    undodir = vim.fn.stdpath('cache') .. '/undo',
    undolevels = 10000,
    autoread = true, -- autoread changes from other sources
    signcolumn = 'yes',
    cursorline = true,
    cursorlineopt = 'number',
    wrap = false,
    scrolloff = 3,
    ruler = false,        -- removes cursor position from lastline
    pumheight = 10,       -- size of completion window
    showmode = false,     -- do not show mode under statusline
    swapfile = false,     -- creates a swapfile
    backup = false,       -- creates a backup file
    writebackup = false,  -- do not edit backups
    winminwidth = 5,      -- Minimum window width
    termguicolors = true, -- set term gui colors (most terminals support this)
    showtabline = 0,      -- always show tabs
    showcmd = false,
    mouse = 'a',          -- allow the mouse to be used in neovim
    confirm = true,       -- Confirm to save changes before exiting modified buffer

    -- tabs
    smarttab = true,
    tabstop = 4,        -- 1 tab represented as 4 spaces
    expandtab = true,   -- <tab> key will create " " instead of "\t"
    shiftwidth = 4,     -- indent change after backspace and >> <<
    softtabstop = 4,    -- number of spaces instead of tab
    autoindent = true,  -- auto indent
    smartindent = true, -- make indenting smarter again
    list = true,
    -- listchars = { trail = "", tab = "", nbsp = "_", extends = ">", precedes = "<" }, -- highlight
    showbreak = string.rep(' ', 3),

    -- Search
    ignorecase = true,
    smartcase = true,
    hlsearch = true,
    wildmenu = true,
    wildmode = 'longest:full,full',
    wildoptions = 'pum',

    -- Folds (keep open by default, works well with nvim-ufo)
    foldlevel = 99,
    foldlevelstart = 99,
    foldenable = true,

    -- Window
    splitright = true,
    splitbelow = true,
    title = true,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- netrw file explorer settings
vim.g.netrw_winsize = 20
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 1

vim.opt.path:append({ '**' })
vim.opt.shortmess:append({ W = true, I = true, c = true }) -- disable greeting

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.cmd([[set fillchars+=eob:\ ]])
