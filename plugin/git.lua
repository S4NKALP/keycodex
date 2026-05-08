add({
	"lewis6991/gitsigns.nvim",
	"wintermute-cell/gitignore.nvim", -- .gitignore generator
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	callback = function()
		require("gitsigns").setup({
			signcolumn = true,
			current_line_blame = true,
			attach_to_untracked = false,
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			watch_gitdir = {
				follow_files = true,
			},
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			signs = {
				add = { text = " " },
				change = { text = "󱗜 " },
				delete = { text = "󰍵 " },
				topdelete = { text = "󱥨 " },
				changedelete = { text = "󰾟 " },
				untracked = { text = "󰰧 " },
			},
		})
	end,
})
