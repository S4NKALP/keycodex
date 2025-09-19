return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'ellisonleao/gruvbox.nvim',
    },
    config = function()
        local lualine = require('lualine')

        -- Get gruvbox colors
        local palette = require('gruvbox').palette

        local colors = {
            bg = palette.dark0,
            fg = palette.light1,
            yellow = palette.bright_yellow,
            cyan = palette.bright_aqua,
            darkblue = palette.dark0_hard,
            green = palette.bright_green,
            orange = palette.bright_orange,
            violet = palette.bright_purple,
            magenta = palette.bright_purple,
            blue = palette.bright_blue,
            red = palette.bright_red,
        }

        local mode_color = {
            n = colors.green,
            i = colors.blue,
            v = colors.magenta,
            [''] = colors.magenta,
            V = colors.magenta,
            c = colors.yellow,
            t = colors.red,
            R = colors.orange,
            Rv = colors.orange,
            no = colors.fg,
            s = colors.violet,
            S = colors.violet,
            [''] = colors.violet,
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
            is_note = function()
                local notes_dir = vim.env.NOTES_DIR
                if not notes_dir then
                    return false
                end
                local current_file = vim.fn.expand('%:p')
                return current_file:find(vim.fn.expand(notes_dir), 1, true) == 1
            end,
        }

        local searchcount = { 'searchcount', color = { fg = colors.fg, gui = 'bold' } }
        local selectioncount = { 'selectioncount', color = { fg = colors.fg, gui = 'bold' } }
        local progress = { 'progress', color = { fg = colors.fg, gui = 'bold' } }
        local filetype = { 'filetype', color = { fg = colors.blue, gui = 'bold' } }
        local filesize = { 'filesize', color = { fg = colors.fg, gui = 'bold' }, cond = conditions.buffer_not_empty }
        local fileformat = { 'fileformat', icons_enabled = true, color = { fg = colors.fg, gui = 'bold' } }

        local filename = {
            'filename',
            cond = conditions.buffer_not_empty and conditions.buffer_is_file and conditions.buffer_not_scratch,
            color = { fg = colors.magenta, gui = 'bold' },
        }

        local buffers = {
            'buffers',
            mode = 2,
            cond = conditions.buffer_not_scratch,
            filetype_names = {
                NvimTree = ' ' .. 'Files',
                TelescopePrompt = ' ' .. 'Telescope',
                Avante = ' ' .. 'Avante',
                AvanteInput = ' ' .. 'Avante',
                AvanteSelectedFiles = ' ' .. 'Avante',
                dashboard = ' ' .. 'Dashboard',
                lazy = '󰒲 ' .. 'Lazy',
                mason = ' ' .. 'Mason',
                minifiles = ' ' .. 'Files',
                snacks_picker_input = ' ' .. 'Picker',
                spectre_panel = ' ' .. 'Spectre',
            },
            use_mode_colors = true,
        }

        local branch = {
            'branch',
            icon = ' ',
            fmt = function(str)
                return str:sub(1, 32)
            end,
            color = { fg = colors.green, gui = 'bold' },
        }

        local diff_icons = {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
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
                error = ' ',
                warn = ' ',
                info = ' ',
                hint = '󰠠 ',
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
            icon = ' ',
            color = { fg = colors.fg, gui = 'bold' },
        }

        local encoding = {
            'o:encoding',
            fmt = string.upper,
            cond = conditions.hide_in_width,
            color = { fg = colors.green, gui = 'bold' },
        }

        local function mode(icon)
            icon = icon or ' '
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

        -- Create custom gruvbox theme
        local function gruvbox_custom()
            local function accent_status(accent)
                return {
                    a = { bg = accent, fg = palette.dark0_hard },
                    b = { bg = palette.dark1, fg = accent },
                    c = { bg = palette.dark0, fg = palette.light1 },
                }
            end

            return {
                normal = accent_status(palette.bright_aqua),
                insert = accent_status(palette.bright_green),
                visual = accent_status(palette.bright_purple),
                replace = accent_status(palette.bright_yellow),
                command = accent_status(palette.bright_orange),
                inactive = {
                    a = { bg = palette.dark1, fg = palette.light4 },
                    b = { bg = palette.dark1, fg = palette.light4 },
                    c = { bg = palette.dark1, fg = palette.light4 },
                },
            }
        end

        lualine.setup({
            options = {
                component_separators = '',
                -- section_separators = '',
                theme = gruvbox_custom(),
                disabled_filetypes = {
                    'dashboard',
                },
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
                lualine_c = { mode(' '), 'location', progress, filename },
                lualine_x = { diagnostics, lsp, filetype, filesize, fileformat, encoding },
                lualine_y = {},
                lualine_z = {},
            },
        })
    end,
}
