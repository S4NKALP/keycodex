local Dashboard = {}
local H = {}

Dashboard.config = {
    text = table.concat({
        [[██╗  ██╗███████╗██╗   ██╗ ██████╗ ██████╗ ██████╗ ███████╗██╗  ██╗]],
        [[██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝]],
        [[█████╔╝ █████╗   ╚████╔╝ ██║     ██║   ██║██║  ██║█████╗   ╚███╔╝ ]],
        [[██╔═██╗ ██╔══╝    ╚██╔╝  ██║     ██║   ██║██║  ██║██╔══╝   ██╔██╗ ]],
        [[██║  ██╗███████╗   ██║   ╚██████╗╚██████╔╝██████╔╝███████╗██╔╝ ██╗]],
        [[╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝]],
    }, '\n'),
}

H.buffer_number = 0
H.is_in_vimenter = false

function Dashboard.open(buf_id)
    if H.is_in_vimenter then
        buf_id = vim.api.nvim_get_current_buf()
    end

    if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
        buf_id = vim.api.nvim_create_buf(false, true)
    end

    vim.api.nvim_set_current_buf(buf_id)

    H.make_buffer_autocmd(buf_id)
    H.apply_buffer_options(buf_id)

    Dashboard.refresh(buf_id)

    vim.api.nvim_exec_autocmds('User', {
        pattern = 'KeyCodeXOpened',
    })

    H.is_in_vimenter = false
end

function Dashboard.refresh(buf_id)
    if not vim.api.nvim_buf_is_valid(buf_id) then
        return
    end

    local win = vim.fn.bufwinid(buf_id)
    if win == -1 then
        return
    end

    local lines = H.create_lines(Dashboard.config.text, win)

    vim.bo[buf_id].modifiable = true
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
    vim.bo[buf_id].modifiable = false
end

function Dashboard.close(buf_id)
    if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
        pcall(vim.api.nvim_buf_delete, buf_id, {
            force = true,
        })
    end
end

function H.create_autocommands()
    local group = vim.api.nvim_create_augroup('KeyCodeXDashboard', { clear = true })

    vim.api.nvim_create_autocmd('VimEnter', {
        group = group,
        nested = true,
        once = true,
        desc = 'Open KEYCODEX on startup',
        callback = function()
            if H.is_something_shown() then
                return
            end

            H.is_in_vimenter = true
            Dashboard.open()
        end,
    })
end

function H.make_buffer_autocmd(buf_id)
    local group = vim.api.nvim_create_augroup('KeyCodeXBuffer' .. buf_id, { clear = true })

    vim.api.nvim_create_autocmd({
        'VimResized',
        'WinResized',
    }, {
        group = group,
        callback = function()
            Dashboard.refresh(buf_id)
        end,
        desc = 'Recenter KEYCODEX logo',
    })

    vim.api.nvim_create_autocmd('BufLeave', {
        group = group,
        buffer = buf_id,
        callback = function()
            if vim.o.cmdheight > 0 then
                vim.cmd("echo ''")
            end
        end,
    })

    vim.api.nvim_create_autocmd('InsertEnter', {
        group = group,
        buffer = buf_id,
        once = true,
        callback = function()
            vim.schedule(function()
                Dashboard.close(buf_id)
            end)
        end,
        desc = 'Close KEYCODEX on insert',
    })

    vim.api.nvim_create_autocmd('BufWipeout', {
        group = group,
        buffer = buf_id,
        once = true,
        callback = function()
            pcall(vim.api.nvim_del_augroup_by_id, group)
        end,
    })
end

function H.apply_buffer_options(buf_id)
    H.buffer_number = H.buffer_number + 1

    local name = H.buffer_number == 1 and 'KEYCODEX' or ('KEYCODEX_' .. H.buffer_number)

    vim.api.nvim_buf_set_name(buf_id, name)

    vim.bo[buf_id].buftype = 'nofile'
    vim.bo[buf_id].bufhidden = 'wipe'
    vim.bo[buf_id].buflisted = false
    vim.bo[buf_id].swapfile = false
    vim.bo[buf_id].modifiable = false
    vim.bo[buf_id].modeline = false
    vim.bo[buf_id].filetype = 'keycodex'

    local win = vim.api.nvim_get_current_win()

    for option, value in pairs({
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        signcolumn = 'no',
        foldcolumn = '0',
        colorcolumn = '',
        wrap = false,
        list = false,
        spell = false,
    }) do
        vim.wo[win][option] = value
    end
end

function H.create_lines(text, win)
    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)

    local text_lines = vim.split(text, '\n', {
        plain = true,
        trimempty = true,
    })

    local top = math.max(0, math.floor((height - #text_lines) / 2))

    local lines = {}

    for _ = 1, top do
        lines[#lines + 1] = ''
    end

    for _, line in ipairs(text_lines) do
        local padding = math.max(0, math.floor((width - vim.fn.strdisplaywidth(line)) / 2))

        lines[#lines + 1] = string.rep(' ', padding) .. line
    end

    for _ = #lines + 1, height do
        lines[#lines + 1] = ''
    end

    return lines
end

function H.is_something_shown()
    if vim.fn.argc() > 0 then
        return true
    end

    local listed = vim.tbl_filter(function(buf)
        return vim.fn.buflisted(buf) == 1
    end, vim.api.nvim_list_bufs())

    if #listed > 1 then
        return true
    end

    local buf = vim.api.nvim_get_current_buf()

    if vim.bo[buf].buftype ~= '' or vim.api.nvim_buf_get_name(buf) ~= '' or vim.bo[buf].modified then
        return true
    end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    return #lines ~= 1 or lines[1] ~= ''
end

-- Initialize automatically without setup()
H.create_autocommands()

return Dashboard
