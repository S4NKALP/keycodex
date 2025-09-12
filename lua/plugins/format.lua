return {
	"stevearc/conform.nvim",
	dependencies = { "zapling/mason-conform.nvim" },
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = { "<leader>tf" },
	config = function()
		require("conform").setup({
			formatters = {
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%-% toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},
			formatters_by_ft = {
				["lua"] = { "stylua" },
				["python"] = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				["javascript"] = { "prettier" },
				["typescript"] = { "prettier" },
				["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
				["mdx"] = { "prettier" },
				["_"] = { "trim_whitespace" },
			},
			options = {
				stop_after_first = true,
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
				"ruff",
				"stylua",
				"prettier",
				"markdown-toc",
				"markdownlint-cli2",
			},
			automatic_installation = true,
		})
	end,
}
