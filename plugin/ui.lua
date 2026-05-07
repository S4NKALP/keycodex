add({
	"m4xshen/smartcolumn.nvim", -- smart column when needed
	"karb94/neoscroll.nvim", -- smooth scrolling
	"OXY2DEV/markview.nvim", -- rendering for html and markdown
	"serhez/bento.nvim", -- buffer manager
	{ src = "akinsho/toggleterm.nvim", version = "*" }, --float terminal
	"max397574/better-escape.nvim", -- better escape
	"zbirenbaum/neodim", -- dimming the highlights of unused functions, variables, parameters, and more
})

-- lazy load UI enhancement plugins
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	callback = function()
		require("neoscroll").setup({
			mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
		})
		require("neodim").setup({
			alpha = 0.5,
			blend_color = nil,
			hide = {
				underline = true,
				virtual_text = true,
				signs = true,
			},
			regex = {
				"[uU]nused",
				"[nN]ever [rR]ead",
				"[nN]ot [rR]ead",
			},
			priority = 128,
			disable = {},
		})
	end,
})

-- lazy load markdown preview
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		require("markview").setup({
			preview = {
				icon_provider = "mini",
				enable = false,
			},
		})
	end,
})
vim.keymap.set("n", "<leader>cv", "<cmd>Markview toggle<cr>", { desc = "toggle markdown preview" })

-- smart column only when needed
require("smartcolumn").setup({
	colorcolumn = 120,
	disabled_filetypes = {
		"help",
		"text",
		"markdown",
		"oil",
		"snacks_dashboard",
		"dashboard",
	},
})

require("bento").setup({})

require("toggleterm").setup({
	size = 10,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = "2",
	start_in_insert = true,
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

-- lazy load better escape
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		require("better_escape").setup({
			mappings = {
				i = {
					k = { j = "<Esc>" },
					j = { k = "<Esc>", j = "<Esc>" },
					-- disable jj
					-- j = { j = false },
				},
			},
		})
	end,
	once = true,
})
