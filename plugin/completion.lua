add({
	"saghen/blink.lib",
	{ src = "saghen/blink.cmp", version = "v0.*" },
	"L3MON4D3/LuaSnip",
	"rafamadriz/friendly-snippets",
})

require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust" },
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {},
	},

	completion = {
		ghost_text = { enabled = true },

		list = {
			selection = {
				preselect = false,
				auto_insert = true,
			},
		},
		documentation = {
			window = { border = "rounded" },
			auto_show = true,
			auto_show_delay_ms = 50,
		},
		menu = {
			border = "rounded",
			draw = {
				components = {
					kind_icon = {
						text = function(ctx)
							local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
							return kind_icon
						end,
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
					kind = {
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
				},
			},
		},
	},
	signature = {
		window = { border = "rounded" },
	},
	keymap = {
		preset = "none",
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<C-space>"] = { "hide", "show" },
		["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-u>"] = { "scroll_documentation_up", "fallback" },
		["<C-d>"] = { "scroll_documentation_down", "fallback" },
	},
})

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/snippets" },
})

luasnip.filetype_extend("mdx", { "markdown" })
