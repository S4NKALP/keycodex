local lualine = require('lualine')
local icons = require('lib.icons')

-- Get colors from base46 theme (chadwal)
local colors = require("base46").get_theme_tb "base_30"

local mode_color = {
    n = colors.green,
    i = colors.blue,
    v = colors.pink,
    [''] = colors.pink,
    V = colors.pink,
    c = colors.yellow,
    t = colors.red,
    R = colors.orange,
    Rv = colors.orange,
    no = colors.white,
    s = colors.purple,
    S = colors.purple,
    [''] = colors.purple,
    ic = colors.yellow,
    cv = colors.red,
    ce = colors.red,
    r = colors.cyan,
    rm = colors.cyan,
    ['r?'] = colors.cyan,
    ['!'] = colors.red,
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    buffer_is_file = function()
        return vim.bo.buftype == ''
    end,
    buffer_not_scratch = function()
        return string.find(vim.fn.bufname(), 'SCRATCH') == nil
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

local searchcount = { 'searchcount', color = { fg = colors.white, gui = 'bold' } }
local selectioncount = { 'selectioncount', color = { fg = colors.white, gui = 'bold' } }
local progress = { 'progress', color = { fg = colors.white, gui = 'bold' } }
local filetype = { 'filetype', color = { fg = colors.blue, gui = 'bold' } }
local filesize = { 'filesize', color = { fg = colors.white, gui = 'bold' }, cond = conditions.buffer_not_empty }
local fileformat = { 'fileformat', icons_enabled = true, color = { fg = colors.white, gui = 'bold' } }

local filename = {
    'filename',
    cond = conditions.buffer_not_empty and conditions.buffer_is_file and conditions.buffer_not_scratch,
    color = { fg = colors.pink, gui = 'bold' },
}

local buffers = {
    'buffers',
    mode = 2,
    cond = conditions.buffer_not_scratch,
    filetype_names = {
        NvimTree = icons.documents.OpenFolder .. 'Files',
        TelescopePrompt = icons.ui.Telescope .. 'Telescope',
        Avante = icons.ui.Copilot .. 'Avante',
        AvanteInput = icons.ui.Pencil .. 'Avante',
        AvanteSelectedFiles = icons.documents.File .. 'Avante',
        dashboard = icons.ui.Dashboard .. 'Dashboard',
        lazy = icons.ui.Sleep .. 'Lazy',
        mason = icons.ui.Package .. 'Mason',
        minifiles = icons.documents.OpenFolder .. 'Files',
        snacks_picker_input = icons.ui.Telescope .. 'Picker',
        spectre_panel = icons.ui.Search .. 'Spectre',
    },
    use_mode_colors = true,
}

local branch = {
    'branch',
    icon = icons.git.Branch,
    fmt = function(str)
        return str:sub(1, 32)
    end,
    color = { fg = colors.green, gui = 'bold' },
}

local diff_icons = {
    'diff',
    symbols = { added = icons.git.AddAlt, modified = icons.git.DiffAlt, removed = icons.git.RemoveAlt },
    diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
}

local diagnostics = {
    'diagnostics',
    sources = { 'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic' },
    symbols = {
        error = icons.diagnostics.Error,
        warn = icons.diagnostics.Warning,
        info = icons.diagnostics.Information,
        hint = icons.diagnostics.Hint,
    },
    diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.blue },
        color_hint = { fg = colors.yellow },
    },
}

local lsp = {
    function()
        local msg = 'No LSP'
        local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config and client.config.filetypes or nil
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = icons.ui.Gear,
    color = { fg = colors.white, gui = 'bold' },
}

local encoding = {
    'o:encoding',
    fmt = string.upper,
    cond = conditions.hide_in_width,
    color = { fg = colors.green, gui = 'bold' },
}

local function mode(icon)
    icon = icon or icons.ui.Neovim
    return {
        function()
            return icon
        end,
        color = function()
            return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { left = 1, right = 0 },
    }
end

-- Create a custom theme based on chadwal colors (onedark style)
local custom_theme = {
    normal = {
        a = { fg = colors.black, bg = colors.green, gui = 'bold' },
        b = { fg = colors.white, bg = colors.one_bg },
        c = { fg = colors.light_grey, bg = 'NONE' },
    },
    insert = {
        a = { fg = colors.black, bg = colors.blue, gui = 'bold' },
        b = { fg = colors.white, bg = colors.one_bg },
        c = { fg = colors.light_grey, bg = 'NONE' },
    },
    visual = {
        a = { fg = colors.black, bg = colors.pink, gui = 'bold' },
        b = { fg = colors.white, bg = colors.one_bg },
        c = { fg = colors.light_grey, bg = 'NONE' },
    },
    replace = {
        a = { fg = colors.black, bg = colors.red, gui = 'bold' },
        b = { fg = colors.white, bg = colors.one_bg },
        c = { fg = colors.light_grey, bg = 'NONE' },
    },
    command = {
        a = { fg = colors.black, bg = colors.yellow, gui = 'bold' },
        b = { fg = colors.white, bg = colors.one_bg },
        c = { fg = colors.light_grey, bg = 'NONE' },
    },
    inactive = {
        a = { fg = colors.grey, bg = 'NONE' },
        b = { fg = colors.grey, bg = 'NONE' },
        c = { fg = colors.grey, bg = 'NONE' },
    },
}

lualine.setup({
    options = {
        component_separators = '',
        section_separators = { left = '', right = '' },
        theme = custom_theme,
        disabled_filetypes = {
            'dashboard',
        },
        globalstatus = true,
    },
    -- extensions = { 'quickfix', 'man', 'mason', 'lazy', 'toggleterm', 'nvim-tree' },
    tabline = {
        lualine_a = {},
        lualine_b = { mode(), buffers },
        lualine_c = {},
        lualine_x = { diff_icons, branch },
        lualine_y = { searchcount, selectioncount },
        lualine_z = {},
    },
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { mode(icons.ui.Heart), 'location', progress, filename },
        lualine_x = { diagnostics, lsp, filetype, filesize, fileformat, encoding },
        lualine_y = {},
        lualine_z = {},
    },
})
