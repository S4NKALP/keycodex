add({
	"mfussenegger/nvim-lint", -- linter
	"rshkarin/mason-nvim-lint", -- linter installer
	"stevearc/conform.nvim", -- autoformater
	"zapling/mason-conform.nvim", -- formatter installer
})

-- linter
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
	ensure_installed = require("extensions").linter,
	automatic_installation = false,
})

-- formatter
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
		["c"] = { "clang_format" },
		["cpp"] = { "clang_format" },
		["h"] = { "clang_format" },
		["python"] = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		["javascript"] = { "biome" },
		["typescript"] = { "biome" },
		["typescriptreact"] = { "biome" },
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
end, { desc = "Toggle autoformat" })
require("mason-conform").setup({
	ensure_installed = require("extensions").formatter,
	automatic_installation = true,
})
