return {
	"stevearc/conform.nvim",
	dependencies = { "zapling/mason-conform.nvim" },
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = { "<leader>tf" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				["_"] = { "trim_whitespace" },
			},
			format_after_save = function(bufnr)
				if not vim.b[bufnr].conform_disable then
					return {
						lsp_format = "fallback",
					}
				end
			end,
		})

		vim.keymap.set("n", "<leader>tf", function()
			vim.b.conform_disable = not vim.b.conform_disable
			local status = vim.b.conform_disable and "disabled" or "enabled"
			vim.notify("Autoformat " .. status, vim.log.levels.INFO)
		end)
		require("mason-conform").setup({
			ensure_installed = {
				"black",
				"stylua",
				"prettier",
			},
			automatic_installation = true,
		})
	end,
}
