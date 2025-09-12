return {
	{
		"Exafunction/windsurf.vim",
		event = "VeryLazy",
		config = function()
			vim.keymap.set("i", "<A-f>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true })
			vim.keymap.set("i", "<A-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, silent = true })
		end,
	},
}
