return {

	--harpoon
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		keys = {
			{
				"<A-1>",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "buffer j",
			},
			{
				"<A-2>",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "buffer k",
			},
			{
				"<A-3>",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "buffer l",
			},
			{
				"<A-4>",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "buffer ;",
			},
		},
	},

	-- better escape
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				mappings = {
					-- i for insert, other modes are the first letter too
					i = {
						-- map kj to exit insert mode
						k = {
							j = "<Esc>",
						},
						-- map jk and jj  to exit insert mode
						j = {
							k = "<Esc>",
							j = "<Esc>",
						},
						-- disable jj
						j = {
							j = false,
						},
					},
				},
			})
		end,
	},

	-- Navigator
	{
		"numToStr/Navigator.nvim",
		event = "VeryLazy",
		config = function()
			require("Navigator").setup({
				auto_save = "current",
				disable_on_zoom = false,
				mux = "auto",
			})
		end,
	},

	-- float terminal
	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm" },
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 10,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = "2",
				start_in_insert = true,
				insert_mappings = true,
				terminal_mappings = true,
				persist_size = true,
				direction = "float", -- Use 'float' for floating terminal windows
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved", -- or 'single', 'double', 'shadow', etc.
					winblend = 0, -- Set to 0 for full transparency
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})
		end,
	},
	{
		"nvzone/floaterm",
		dependencies = "nvzone/volt",
		opts = {
			mappings = {
				term = function(buf)
					vim.keymap.set({ "n", "t" }, "<Tab>", function()
						require("floaterm.api").cycle_term_bufs("prev")
					end, { buffer = buf })
				end,
			},
		},
		cmd = "FloatermToggle",
	},

	-- smooth scrolling
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},

	-- discord presence
	-- {
	-- 	"vyfor/cord.nvim",
	-- 	event = "VeryLazy",
	-- },

	-- uv
	{
		"benomahony/uv.nvim",
		ft = "python",
		event = "BufReadPre",
		opts = {
			picker_integration = true,
			keymaps = {
				prefix = "<leader>u", -- Main prefix for uv commands
				commands = true, -- Show uv commands menu (<leader>x)
				run_file = true, -- Run current file (<leader>xr)
				run_selection = true, -- Run selected code (<leader>xs)
				run_function = true, -- Run function (<leader>xf)
				venv = true, -- Environment management (<leader>xe)
				init = true, -- Initialize uv project (<leader>xi)
				add = true, -- Add a package (<leader>xa)
				remove = true, -- Remove a package (<leader>xd)
				sync = true, -- Sync packages (<leader>xc)
				sync_all = true, -- Sync all packages, extras and groups (<leader>xC)
			},
		},
	},

	-- Project management
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				detection_methods = { "lsp", "pattern" },
				patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
			})
		end,
	},

	{ "wakatime/vim-wakatime", event = "VimEnter", lazy = false },

	-- {
	-- 	"m4xshen/hardtime.nvim",
	-- 	lazy = false,
	-- 	opts = {},
	-- },

	-- file operations
	{
		"chrisgrieser/nvim-genghis",
		keys = {
			{
				"<leader>fp",
				function()
					require("genghis").createNewFile()
				end,
				desc = "New File",
			},
			{
				"<leader>fd",
				function()
					require("genghis").duplicateFile()
				end,
				desc = "Duplicate File",
			},
			{
				"<leader>fr",
				function()
					require("genghis").renameFile()
				end,
				desc = "Rename File",
			},
			{
				"<leader>fx",
				function()
					require("genghis").chmodx()
				end,
				desc = "Make Executable",
			},
		},
	},
}
