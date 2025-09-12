return {
	"mfussenegger/nvim-lint",
	dependencies = { "rshkarin/mason-nvim-lint" },
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{
			"<leader>L",
			mode = { "n" },
			function()
				require("lint").try_lint()
			end,
			desc = "Trigger linting for current file",
		},
	},
	config = function()
		require("lint").linters_by_ft = {
			["*"] = { "codespell" },
			["javascript"] = { "eslint_d", "cspell" },
			["typescript"] = { "eslint_d", "cspell" },
			["javascriptreact"] = { "eslint_d", "cspell" },
			["typescriptreact"] = { "eslint_d", "cspell" },
			["dockerfile"] = { "hadolint" },
			["markdown"] = { "write_good", "markdownlint" },
			["text"] = { "write_good" },
			["sh"] = { "shellcheck" },
			["yaml"] = { "actionlint" },
			["python"] = { "ruff" },
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
				"codespell",
				"cspell",
			},
			automatic_installation = true,
		})
	end,
}
