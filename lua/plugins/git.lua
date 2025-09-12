return {

	-- git signs
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = {
					text = "+",
				},
				change = {
					text = "▎",
				},
				delete = {
					text = "",
				},
				topdelete = {
					text = "▾",
				},
				changedelete = {
					text = "~",
				},
				untracked = {
					text = "┆",
				},
			},
			signs_staged = {
				add = {
					text = "+",
				},
				change = {
					text = "▎",
				},
				delete = {
					text = "",
				},
				topdelete = {
					text = "▾",
				},
				changedelete = {
					text = "~",
				},
			},
		},
	},

	-- lazygit integration
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		enabled = false,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
