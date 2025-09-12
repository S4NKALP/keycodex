return {
	-- surround actions
	{
		"nvim-mini/mini.surround",
		version = "*",
		config = function()
			require("mini.surround").setup()
		end,
	},

	-- indent guides
	{
		"nvim-mini/mini.indentscope",
		event = "VeryLazy",
		config = function()
			require("mini.indentscope").setup({
				draw = {
					delay = 50,
					animation = require("mini.indentscope").gen_animation.linear({
						ease = "out",
						duration = 15,
					}),
				},
				options = {
					border = "top",
					try_as_border = true,
					indent_at_cursor = false,
				},
			})

			-- disable for certain filetypes
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function(args)
					if vim.bo[args.buf].buftype ~= "" then
						vim.b[args.buf].miniindentscope_disable = true
					end
				end,
			})
		end,
	},

	-- Go forward/backward with square brackets
	{
		"echasnovski/mini.bracketed",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("mini.bracketed").setup()
		end,
	},

	-- textobjects
	{
		"nvim-mini/mini.ai",
		version = "*",
		config = function()
			require("mini.ai").setup({
				silent = true,
			})
		end,
	},

	-- hiding colorcolumn when unneeded.
	{
		"m4xshen/smartcolumn.nvim",
		opts = {
			disabled_filetypes = {
				"netrw",
				"NvimTree",
				"Lazy",
				"mason",
				"help",
				"text",
				"markdown",
				"tex",
				"html",
			},
			custom_colorcolumn = { lua = "90", python = "100" },
			scope = "window",
		},
	},

	-- Dimming the highlights of unused functions, variables, parameters, and more.
	{
		"zbirenbaum/neodim",
		enabled = false,
		event = "LspAttach",
		config = function()
			require("neodim").setup({
				alpha = 0.5,
				blend_color = nil,
				hide = {
					underline = true,
					virtual_text = true,
					signs = true,
				},
				regex = {
					"[uU]nused",
					"[nN]ever [rR]ead",
					"[nN]ot [rR]ead",
				},
				priority = 128,
				disable = {},
			})
		end,
	},

	{
		"numToStr/Comment.nvim",
		version = false,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
				mappings = {
					basic = true,
					extra = true,
				},
			})
		end,
		keys = {
			{ "gcc", mode = "n", desc = "Toggle comment line" },
			{ "gc", mode = { "n", "o" }, desc = "Toggle comment linewise" },
			{ "gc", mode = "x", desc = "Toggle comment linewise (visual)" },
			{ "gbc", mode = "n", desc = "Toggle comment block" },
			{ "gb", mode = { "n", "o" }, desc = "Toggle comment blockwise" },
			{ "gb", mode = "x", desc = "Toggle comment blockwise (visual)" },
			{ "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", desc = "Toggle comment" },
			{
				"<leader>/",
				"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
				desc = "Toggle comment",
				mode = "v",
			},
		},
		opts = {},
	},

	-- Todo Comments
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		opts = {},
	},

	-- inline diagnostic
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
		end,
	},

	-- code action
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{
				"folke/snacks.nvim",
				opts = {
					terminal = {},
				},
			},
		},
		event = "LspAttach",
		config = function()
			local codeaction = require("tiny-code-action")

			codeaction.setup({
				picker = {
					"buffer",
					opts = {
						auto_preview = true,
						hotkeys = true,
						hotkeys_mode = "sequential",
					},
				},
			})

			vim.keymap.set("n", "<leader>.", codeaction.code_action)
		end,
	},

	-- visual multi
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<M-d>",
				["Find Subword Under"] = "<M-d>",
				["Select All"] = "<C-M-d>",
				["Add Cursor Down"] = "<C-M-j>",
				["Add Cursor Up"] = "<C-M-k>",
			}
		end,
	},
}
