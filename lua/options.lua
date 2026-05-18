local options = {
	ai = true,
	clipboard = "unnamedplus", -- use system clipboard
	number = true,
	relativenumber = true,
	undofile = true, -- save state of file on write
	undodir = vim.fn.stdpath("cache") .. "/undo",
	undolevels = 10000,
	signcolumn = "yes",
	cursorline = true,
	cursorlineopt = "number",
	wrap = false,
	scrolloff = 3,
	ruler = false, -- removes cursor position from lastline
	pumheight = 10, -- size of completion window
	showmode = false, -- do not show mode under statusline
	swapfile = false, -- creates a swapfile
	backup = false, -- creates a backup file
	writebackup = false, -- do not edit backups
	winminwidth = 5, -- Minimum window width
	showtabline = 0, -- always show tabs
	showcmd = false,
	confirm = true, -- Confirm to save changes before exiting modified buffer

	-- tabs
	smarttab = true,
	tabstop = 4, -- 1 tab represented as 4 spaces
	expandtab = true, -- <tab> key will create " " instead of "\t"
	shiftwidth = 4, -- indent change after backspace and >> <<
	softtabstop = 4, -- number of spaces instead of tab
	list = true,
	listchars = { tab = "» ", trail = "·", nbsp = "␣" },
	showbreak = string.rep(" ", 3),

	-- Search
	ignorecase = true,
	smartcase = true,
	wildmode = "longest:full,full",
	wildoptions = "pum",

	-- Window
	splitright = true,
	splitbelow = true,
	title = true,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.path:append({ "**" })
vim.opt.shortmess:append({ W = true, I = true, c = true }) -- disable greeting

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.cmd([[set fillchars+=eob:\ ]])

vim.filetype.add({
	extension = {
		astro = "astro",
		ejs = "ejs",
		hbs = "hbs",
		njk = "nunjucks",
		postcss = "postcss",
		razor = "razor",
		slim = "slim",
		sugarss = "sugarss",
		edge = "edge",
		jade = "jade",
		leaf = "leaf",
		erb = "erb",
		gohtml = "gohtml",
		gohtmltmpl = "gohtmltmpl",
	},
})
