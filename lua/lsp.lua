--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("User", {
	pattern = "PackerComplete", -- Fallback or custom event if needed, but let's use a more standard one
	callback = function()
		-- This is where we would put it if we had a specific event.
		-- Since we're using VimEnter, let's use that instead.
	end,
})

-- Let's use a simple function and schedule it to run after plugins
vim.schedule(function()
	vim.lsp.config("*", {
		capabilities = require("blink.cmp").get_lsp_capabilities(),
	})

	-- ts_ls
	vim.lsp.config("ts_ls", {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	})
	vim.lsp.enable("ts_ls")

	vim.lsp.enable("html")
	vim.lsp.enable("cssls")
	vim.lsp.enable("tailwindcss")

	-- rust
	vim.lsp.config("rust_analyzer", {
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					enable = true,
					experimental = { enable = true },
				},
			},
		},
	})
	vim.lsp.enable("rust_analyzer")

	-- lua
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = {
					disable = {
						"missing-fields",
						"undefined-global",
					},
				},
			},
		},
	})
	vim.lsp.enable("lua_ls")

	-- python
	vim.lsp.config("basedpyright", {
		settings = {
			basedpyright = {
				inlayHints = true,
				analysis = {
					diagnosticSeverityOverrides = {
						reportUnusedImport = "none",
						reportUnusedVariable = "none",
						reportAttributeAccessIssue = "none",
						reportUnusedClass = "none",
						reportUnusedFunction = "none",
						reportDuplicateImport = "none",
						reportArgumentType = "error",
					},
					typeCheckingMode = "standard",
				},
			},
		},
	})
	vim.lsp.enable("basedpyright")

	-- bash
	vim.lsp.config("bashls", {
		settings = {
			bashIde = {
				shellcheckArguments = {
					"--exclude=SC1090,SC1091,SC2076,SC2164",
				},
			},
		},
	})
	vim.lsp.enable("bashls")

	-- cpp
	vim.lsp.config("clangd", {
		cmd = {
			"clangd",
			"--fallback-style=llvm",
			"--header-insertion=iwyu",
			"-j=4",
		},
	})
	vim.lsp.enable("clangd")
end)
