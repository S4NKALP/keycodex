local function augroup(name)
	return vim.api.nvim_create_augroup("nvim_" .. name, { clear = true })
end

-- smart column only when needed
local smart_column_group = vim.api.nvim_create_augroup('SmartColumn', { clear = true })
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufEnter' }, {
    group = smart_column_group,
    callback = function()
        local limit = 120
        local disabled_fts = { 'help', 'text', 'markdown', 'oil', 'snacks_dashboard', 'dashboard' }

        if vim.tbl_contains(disabled_fts, vim.bo.filetype) then
            vim.wo.colorcolumn = ''
            return
        end

        local curr_line = vim.api.nvim_get_current_line()
        if vim.fn.strdisplaywidth(curr_line) > limit then
            vim.wo.colorcolumn = tostring(limit)
        else
            vim.wo.colorcolumn = ''
        end
    end,
})

-- Secure .env Masking (Conceal method)
local function toggle_env_mask()
	local buf = vim.api.nvim_get_current_buf()
	if vim.wo.conceallevel > 0 then
		vim.wo.conceallevel = 0
		vim.notify("Env masking disabled", vim.log.levels.INFO, { title = "Security" })
	else
		vim.wo.conceallevel = 2
		vim.wo.concealcursor = "n" -- Show when editing (insert mode)
		vim.notify("Env masking enabled", vim.log.levels.INFO, { title = "Security" })
	end
end

-- Auto-mask .env files on load
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = augroup("env_masking"),
	pattern = { ".env", ".env.*", "*.env" },
	callback = function()
		vim.opt_local.conceallevel = 2
		vim.opt_local.concealcursor = "n"
		-- Match everything after '=' (only if not empty) and conceal it with '*'
		vim.fn.matchadd("Conceal", [[=\zs.\+]], 10, -1, { conceal = "*" })
	end,
})

vim.keymap.set("n", "<leader>ot", toggle_env_mask, { desc = "Toggle .env masking" })


-- Strip trailing spaces before write
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("strip_space"),
	pattern = "*",
	callback = function()
		local save = vim.fn.winsaveview()
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.fn.winrestview(save)
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close specific filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"help", "lspinfo", "man", "notify", "qf", "query", "spectre_panel",
		"startuptime", "tsplayground", "neotest-output", "checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Auto-create directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Document Highlight on CursorHold
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp_attach_autocmds"),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.supports_method("textDocument/documentHighlight") then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})

-- Wrap and spellcheck in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Disable auto-commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("no_auto_comment"),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})


-- Manual Treesitter Installation command
vim.api.nvim_create_user_command("TSInstallAll", function()
	local parsers = require("extensions").ts_parsers
	vim.notify("Installing all configured Tree-sitter parsers...", vim.log.levels.INFO, { title = "Tree-sitter" })
	require("nvim-treesitter.install").install(parsers)
end, { desc = "Install all configured Tree-sitter parsers" })


-- Macro Notifications
vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		vim.notify("Recording macro...", vim.log.levels.INFO, { title = "Macro", timeout = 1000 })
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function()
		local reg = vim.v.recording
		vim.notify("Stopped recording @" .. reg, vim.log.levels.INFO, { title = "Macro", timeout = 1000 })
	end,
})


-- Auto-Save (3s Debounce)
local save_timer = nil
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "BufLeave", "FocusLost" }, {
	group = augroup("autosave"),
	callback = function(args)
		if not vim.bo[args.buf].modified or vim.bo[args.buf].buftype ~= "" then
			return
		end
		if save_timer then
			save_timer:stop()
		end

		local delay = (args.event == "BufLeave" or args.event == "FocusLost") and 0 or 3000
		save_timer = vim.defer_fn(function()
			if vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].modified then
				vim.api.nvim_buf_call(args.buf, function()
					vim.cmd("silent! write")
				end)
			end
		end, delay)
	end,
})
