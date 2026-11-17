-- Reindent pasted text so it lands at the indentation level of its surroundings.
--
-- Covers:
--   * terminal/clipboard paste and `vim.paste()` (through the override below)
--   * normal mode `p`, `P`, `gp`, `gP` (mapped in `lua/keys.lua`)
--
-- Reindenting only happens when the buffer has real indent rules
-- ('indentexpr', 'cindent' or 'lisp'), so plain text buffers are left alone.
-- Set `vim.g.autoindent_paste = false` to turn it off.

local M = {}

local orig_paste = vim.paste
local pending = nil

--- @param buf integer
--- @return boolean
local function indent_supported(buf)
    local bo = vim.bo[buf]
    if not bo.modifiable or bo.readonly or bo.buftype ~= '' then
        return false
    end
    return bo.indentexpr ~= '' or bo.cindent or bo.lisp
end

local function enabled(buf)
    return vim.g.autoindent_paste ~= false and indent_supported(buf)
end

--- Reindent lines `first`..`last` in `buf`, keeping cursor and insert mode intact
--- @param buf integer
--- @param first integer
--- @param last integer
local function reindent(buf, first, last)
    if last < first then
        return
    end

    local win = vim.api.nvim_get_current_win()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local inserting = vim.api.nvim_get_mode().mode:match('^[iR]') ~= nil

    if inserting then
        -- Leaving insert mode here does not reliably re-enter it, so run the
        -- reindent through <C-o> instead: it temporarily executes one normal
        -- mode command and drops straight back into insert mode.
        -- Cursor ends up after the last pasted line, where typing continues.
        vim.schedule(function()
            pcall(vim.cmd, 'undojoin')
            local keys = vim.api.nvim_replace_termcodes(
                ('<C-o>:silent keepjumps %d,%dnormal! ==<cr><C-o>:call cursor(%d, strlen(getline(%d)) + 1)<cr>'):format(
                    first,
                    last,
                    last,
                    last
                ),
                true,
                false,
                true
            )
            vim.api.nvim_feedkeys(keys, 'n', false)
        end)
        return
    end

    -- The whole mapping already runs as a single undo block, so no `undojoin`
    -- here: it would merge the reindent into the user's previous change.
    vim.api.nvim_buf_call(buf, function()
        vim.cmd(('silent keepjumps %d,%dnormal! =='):format(first, last))
    end)
    pcall(vim.api.nvim_win_set_cursor, win, cursor)
end

--- Reindent the text just put with `p`/`P`/`gp`/`gP`
function M.reindent_put()
    local buf = vim.api.nvim_get_current_buf()
    if not enabled(buf) then
        return
    end

    local first, last = vim.fn.line("'["), vim.fn.line("']")
    if last <= first then
        return
    end

    -- For characterwise/blockwise puts the start line keeps its existing text,
    -- so only touch the lines that came from the register.
    local linewise = vim.fn.getregtype(vim.v.register):sub(1, 1) == 'V'
    if not linewise then
        local start_col = vim.fn.col("'[")
        local line = vim.api.nvim_buf_get_lines(buf, first - 1, first, false)[1] or ''
        if line:sub(1, start_col - 1):match('%S') then
            first = first + 1
        end
    end

    reindent(buf, first, last)
end

--- Normalize the paste phase (Neovim 0.12 dropped the legacy `true` value)
--- @param phase any
--- @return integer
local function norm_phase(phase)
    if phase == true or phase == nil then
        return -1
    end
    return phase
end

--- Hook every paste (terminal, clipboard, `vim.paste()`) and reindent multi-line pastes
function vim.paste(lines, phase)
    local buf = vim.api.nvim_get_current_buf()
    local p = norm_phase(phase)

    if p == 1 or p == -1 then
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        pending = {
            buf = buf,
            lnum = cursor[1],
            -- Paste at the start of a line (only blanks before cursor) => indented first line too
            blank_prefix = line:sub(1, cursor[2]):match('^%s*$') ~= nil,
        }
    end

    local ok, err = orig_paste(lines, p)

    local last_phase = p == 3 or p == -1
    if last_phase and pending and pending.buf == buf then
        local last = vim.api.nvim_win_get_cursor(0)[1]
        local first = pending.blank_prefix and pending.lnum or (pending.lnum + 1)
        if last > first and enabled(buf) then
            reindent(buf, first, last)
        end
    end
    if last_phase or ok == false then
        pending = nil
    end

    return ok, err
end

return M
