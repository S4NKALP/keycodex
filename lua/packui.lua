local M = {}

local state = {
    buf = nil,
    win = nil,
    items = {},
    line_to_item = {},
}

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO, { title = 'vim.pack' })
end

local function close()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end
    state.win = nil
    state.buf = nil
end

local function plugin_name(item)
    return item.spec.name or item.spec.src:match('([^/]+)/*$') or item.spec.src
end

local function plugin_version(item)
    local version = item.spec.version
    if version == nil then
        return ''
    end
    return type(version) == 'string' and version or tostring(version)
end

local function short_rev(rev)
    if not rev or rev == '' then
        return ''
    end
    return rev:sub(1, 7)
end

local function get_items(info)
    local ok, items = pcall(vim.pack.get, nil, { info = info or false })
    if not ok then
        notify(items, vim.log.levels.ERROR)
        return {}
    end

    table.sort(items, function(a, b)
        return plugin_name(a) < plugin_name(b)
    end)

    return items
end

local function item_at_cursor()
    if not state.win or not vim.api.nvim_win_is_valid(state.win) then
        return nil
    end

    local line = vim.api.nvim_win_get_cursor(state.win)[1]
    return state.line_to_item[line]
end

local function render()
    if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
        return
    end

    state.items = get_items(false)
    state.line_to_item = {}

    local lines = {
        '  📦 vim.pack managed plugins',
        '  [u] update  [U] update all  [d] delete  [X] clean inactive  [i] inspect  [o] open  [q] quit',
        '  ─────────────────────────────────────────────────────────────────────────────────',
        '',
        string.format('  %-3s %-30s %-10s %-15s %s', 'Act', 'Plugin', 'Rev', 'Version', 'Source'),
        string.format('  %-3s %-30s %-10s %-15s %s', '───', '──────', '───', '───────', '──────'),
    }

    local ns_id = vim.api.nvim_create_namespace('packui')
    vim.api.nvim_buf_clear_namespace(state.buf, ns_id, 0, -1)

    for _, item in ipairs(state.items) do
        local name = plugin_name(item)
        local status = item.active and ' ● ' or '   '
        local line = string.format(
            '  %-3s %-30s %-10s %-15s %s',
            status,
            name,
            short_rev(item.rev),
            plugin_version(item),
            item.spec.src
        )
        lines[#lines + 1] = line
        state.line_to_item[#lines] = item
    end

    if #state.items == 0 then
        lines[#lines + 1] = '  No plugins managed by vim.pack.'
    end

    vim.bo[state.buf].modifiable = true
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.bo[state.buf].modifiable = false

    -- Highlights
    vim.api.nvim_buf_add_highlight(state.buf, ns_id, 'Title', 0, 0, -1)
    vim.api.nvim_buf_add_highlight(state.buf, ns_id, 'NonText', 1, 0, -1)
    vim.api.nvim_buf_add_highlight(state.buf, ns_id, 'Comment', 2, 0, -1)
    vim.api.nvim_buf_add_highlight(state.buf, ns_id, 'Label', 4, 0, -1)

    for i = 6, #lines do
        local item = state.line_to_item[i]
        if item then
            if item.active then
                vim.api.nvim_buf_add_highlight(state.buf, ns_id, 'DiagnosticOk', i - 1, 2, 5)
            end
            vim.api.nvim_buf_add_highlight(state.buf, ns_id, 'Directory', i - 1, 6, 36)
            vim.api.nvim_buf_add_highlight(state.buf, ns_id, 'Constant', i - 1, 37, 47)
            vim.api.nvim_buf_add_highlight(state.buf, ns_id, 'Special', i - 1, 48, 63)
            vim.api.nvim_buf_add_highlight(state.buf, ns_id, 'Comment', i - 1, 64, -1)
        end
    end
end

local function run_for_item(action)
    local item = item_at_cursor()
    if not item then
        notify('No plugin under cursor', vim.log.levels.WARN)
        return
    end

    action(item, plugin_name(item))
end

local function update_item()
    run_for_item(function(_, name)
        notify('Updating ' .. name .. '...')
        vim.pack.update({ name })
        vim.defer_fn(render, 500)
    end)
end

local function update_all()
    notify('Updating all plugins...')
    vim.pack.update()
    vim.defer_fn(render, 1000)
end

local function delete_item(force)
    run_for_item(function(_, name)
        local choice = vim.fn.confirm('Delete ' .. name .. '?', '&Yes\n&No', 2)
        if choice ~= 1 then
            return
        end

        local ok, err = pcall(vim.pack.del, { name }, { force = force })
        if not ok then
            notify(err, vim.log.levels.ERROR)
            return
        end

        notify('Deleted ' .. name)
        render()
    end)
end

local function delete_inactive()
    local inactive_names = {}
    for _, item in ipairs(state.items) do
        if not item.active then
            table.insert(inactive_names, plugin_name(item))
        end
    end

    if #inactive_names == 0 then
        notify('No inactive plugins to delete')
        return
    end

    local choice = vim.fn.confirm('Delete ' .. #inactive_names .. ' inactive plugins?', '&Yes\n&No', 2)
    if choice ~= 1 then
        return
    end

    notify('Deleting inactive plugins...')
    local ok, err = pcall(vim.pack.del, inactive_names)
    if not ok then
        notify(err, vim.log.levels.ERROR)
        return
    end

    notify('Cleaned ' .. #inactive_names .. ' plugins')
    render()
end

local function inspect_item()
    run_for_item(function(_, name)
        local ok, items = pcall(vim.pack.get, { name }, { info = true })
        if not ok then
            notify(items, vim.log.levels.ERROR)
            return
        end

        vim.print(items[1])
    end)
end

local function open_path()
    run_for_item(function(item)
        close()
        vim.cmd.edit(vim.fn.fnameescape(item.path))
    end)
end

local function yank_source()
    run_for_item(function(item, name)
        vim.fn.setreg('+', item.spec.src)
        notify('Yanked source for ' .. name)
    end)
end

local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { buffer = state.buf, silent = true, nowait = true, desc = desc })
end

function M.open()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_set_current_win(state.win)
        render()
        return
    end

    local width = math.min(120, vim.o.columns - 10)
    local height = math.min(30, vim.o.lines - 10)

    state.buf = vim.api.nvim_create_buf(false, true)
    state.win = vim.api.nvim_open_win(state.buf, true, {
        relative = 'editor',
        style = 'minimal',
        border = 'rounded',
        title = ' 📦 vim.pack ',
        title_pos = 'center',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
    })

    vim.bo[state.buf].bufhidden = 'wipe'
    vim.bo[state.buf].buftype = 'nofile'
    vim.bo[state.buf].filetype = 'packui'
    vim.bo[state.buf].swapfile = false
    vim.wo[state.win].cursorline = true
    vim.wo[state.win].wrap = false

    map('q', close, 'Close UI')
    map('<Esc>', close, 'Close UI')
    map('r', render, 'Refresh')
    map('u', update_item, 'Update plugin')
    map('U', update_all, 'Update all')
    map('d', function() delete_item(false) end, 'Delete plugin')
    map('D', function() delete_item(true) end, 'Force delete')
    map('i', inspect_item, 'Inspect plugin')
    map('o', open_path, 'Open path')
    map('<CR>', open_path, 'Open path')
    map('y', yank_source, 'Yank source')
    map('X', delete_inactive, 'Delete inactive plugins')

    render()
    vim.api.nvim_win_set_cursor(state.win, { 6, 2 })
end

function M.setup()
    vim.api.nvim_create_user_command('Pack', M.open, { desc = 'Open vim.pack plugin UI' })
    vim.api.nvim_create_user_command('PackUI', M.open, { desc = 'Open vim.pack plugin UI' })
end

return M
