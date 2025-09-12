return {
	"mfussenegger/nvim-lint",
	dependencies = { "rshkarin/mason-nvim-lint" },
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("lint").linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			dockerfile = { "hadolint" },
			markdown = { "write_good", "markdownlint" },
			text = { "write_good" },
			sh = { "shellcheck" },
			yaml = { "actionlint" },
			python = { "ruff" },
		}
		require("mason-nvim-lint").setup({
			ensure_installed = {
				"eslint_d",
				"hadolint",
				"write_good",
				"markdownlint",
				"shellcheck",
				"actionlint",
				"djlint",
				"ruff",
				"pylint",
			},
			automatic_installation = true,
		})
	end,
}
