return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		local palette = require("gruvbox").palette
		require("gruvbox").setup({
			bold = false,
			italic = {
				strings = false,
				emphasis = false,
				comments = false,
				folds = false,
			},
			contrast = "hard",
			transparent_mode = true,
			overrides = {
				-- builtin
				SignColumn = { bg = "None" },
				CursorLineNr = { bg = "None" },
				Whitespace = { fg = palette.dark0 },
				EndOfBuffer = { fg = palette.dark0_hard },
				Visual = { fg = "None", bg = palette.dark1 },
				Label = { link = "GruvboxPurple" },

				-- blink.cmp
				BlinkCmpMenu = { link = "Normal" },
				BlinkCmpMenuBorder = { link = "BlinkCmpMenu" },
				BlinkCmpMenuSelection = { fg = "None", bg = palette.dark1 },
				BlinkCmpLabelMatch = { fg = palette.bright_green },
				BlinkCmpScrollBarGutter = { bg = palette.dark2 },
				BlinkCmpScrollBarThumb = { bg = palette.light1 },

				-- indent guides
				MiniIndentscopeSymbol = { fg = palette.dark1 },
			},
		})
		vim.cmd.colorscheme("gruvbox")
	end,
}
