add({
	{ src = "mason-org/mason.nvim", version = "main" }, -- lsp installer manager
	{ src = "mason-org/mason-lspconfig.nvim", version = "main" }, -- lsp installer
	"neovim/nvim-lspconfig", -- lsp config
	"nvimdev/Lspsaga.nvim", -- lsp ui
	"rachartier/tiny-inline-diagnostic.nvim", -- inline diagnostic
	"rachartier/tiny-code-action.nvim", -- code action
})

-- lsp installer
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
	ensure_installed = require("extensions").lsp_server,
	automatic_installation = false, -- Don't auto-install or auto-configure
})

-- improve neovim lsp experience
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
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

		--inline diagnostic
		require("tiny-inline-diagnostic").setup({
			options = {
				show_source = true,
				multiple_diag_under_cursor = true,
			},
		})

		--code action
		require("tiny-code-action").setup({
			picker = {
				"buffer",
				opts = {
					auto_preview = true,
					hotkeys = true,
					hotkeys_mode = "sequential",
				},
			},
		})
	end,
})

vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
vim.keymap.set("n", "<leader>.", function()
	require("tiny-code-action").code_action()
end, { desc = "Code action" })
