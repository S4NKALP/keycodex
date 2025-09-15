return {
	-- default lsp configs
	{
		"neovim/nvim-lspconfig",
		config = function() end,
	},

	-- lsp installer
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		cmd = "Mason",
		config = function()
			-- mason
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
					border = "rounded",
					backdrop = 100,
				},
			})
			require("mason-lspconfig").setup({
				-- list of servers for mason to install
				ensure_installed = {
					"ts_ls",
					"html",
					"cssls",
					"tailwindcss",
					"lua_ls",
					"basedpyright",
					"bashls",
					"clangd",
					-- "pylsp",
					"rust_analyzer",
				},
				-- auto-install configured servers (with lspconfig)
				automatic_installation = true, -- not the same as ensure_installed
			})
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({
				ui = {
					theme = "round",
					border = "rounded",
					devicon = true,
					title = true,
					winblend = 1,
					expand = " ",
					collapse = " ",
					preview = "",
					code_action = "󰠠 ",
					diagnostic = " ",
					incoming = " ",
					outgoing = " ",
					hover = " ",
				},
			})
		end,
	},
}
