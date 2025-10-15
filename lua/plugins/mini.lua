return {
    'echasnovski/mini.nvim',
    config = function()
        require('mini.ai').setup()
        require('mini.pairs').setup()
        require('mini.icons').setup()
        require('mini.bracketed').setup()
        require('mini.tabline').setup()
        require('mini.splitjoin').setup({
            mappings = {
                toggle = '<leader>tj',
                split = '',
                join = '',
            },
        })
        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - asiw) - [Yank] Surrounding Inner Word )Paren (like in surround)
        -- - ds'   - Delete Surround 'quotes
        -- - rs)'  - Replace Surround ) '
        require('mini.surround').setup({
            mappings = {
                add = 'ys',          -- Add surrounding in Normal and Visual modes
                delete = 'ds',       -- Delete surrounding
                find = '',           -- Find surrounding (to the right)
                find_left = '',      -- Find surrounding (to the left)
                highlight = '',      -- Highlight surrounding
                replace = 'cs',      -- Replace surrounding
                update_n_lines = '', -- Update `n_lines`

                suffix_last = 'l',   -- Suffix to search with "prev" method
                suffix_next = 'n',   -- Suffix to search with "next" method
            },
        })
        require('mini.indentscope').setup({
            draw = {
                delay = 50,
                animation = require('mini.indentscope').gen_animation.linear({ ease = 'out', duration = 15 }),
            },
            options = { border = 'top', try_as_border = true, indent_at_cursor = false },
        })

        vim.api.nvim_create_autocmd('BufEnter', {
            pattern = '*',
            callback = function(args)
                if vim.bo[args.buf].buftype ~= '' then
                    vim.b[args.buf].miniindentscope_disable = true
                end
            end,
        })

        require('mini.statusline').setup({
            use_icons = true,
            content = {
                active = function()
                    local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                    local git = MiniStatusline.section_git({ trunc_width = 40 })
                    local diff = MiniStatusline.section_diff({ trunc_width = 80 })
                    local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 60 })
                    local lsp = MiniStatusline.section_lsp({ trunc_width = 40 })
                    local filename = MiniStatusline.section_filename({ trunc_width = 140 })

                    local function section_filetype(args)
                        if
                            MiniStatusline.is_truncated(args.trunc_width)
                            or vim.bo.filetype == ''
                            or vim.bo.buftype ~= ''
                        then
                            return ''
                        end
                        local ok, icons = pcall(require, 'mini.icons')
                        local icon = ok and select(1, icons.get('filetype', vim.bo.filetype)) or ''
                        return string.format('%s %s│', icon, vim.bo.filetype)
                    end

                    local function section_lsp_clients(args)
                        if MiniStatusline.is_truncated(args.trunc_width) then
                            return ''
                        end
                        local clients = vim.lsp.get_clients({ bufnr = 0 })
                        if not clients or #clients == 0 then
                            return ''
                        end
                        local names = vim.tbl_map(function(c)
                            return c.name
                        end, clients)
                        return string.format(' %s', table.concat(names, ', '))
                    end

                    local function section_searchcount(args)
                        if vim.v.hlsearch == 0 then
                            return ''
                        end
                        local ok, s = pcall(vim.fn.searchcount, { recompute = true })
                        if not ok or s.current == nil or s.total == 0 then
                            return ''
                        end
                        local icon = MiniStatusline.is_truncated(args.trunc_width) and '' or ' '
                        if s.incomplete == 1 then
                            return icon .. '?/?│'
                        end
                        local fmt = '>%d'
                        local cur = s.current > s.maxcount and fmt:format(s.maxcount) or s.current
                        local tot = s.total > s.maxcount and fmt:format(s.maxcount) or s.total
                        return ('%s%s/%s│'):format(icon, cur, tot)
                    end

                    local function section_location(args)
                        return MiniStatusline.is_truncated(args.trunc_width) and '%-2l│%-2v'
                            or '󰉸 %-2l│󱥖 %-2v'
                    end

                    local filetype = section_filetype({ trunc_width = 70 })
                    local searchcount = section_searchcount({ trunc_width = 80 })
                    local loc = section_location({ trunc_width = 120 })
                    local lsp_clients = section_lsp_clients({ trunc_width = 60 })

                    return MiniStatusline.combine_groups({
                        { hl = mode_hl,                 strings = { mode:upper() } },
                        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
                        '%<',
                        { hl = 'MiniStatuslineFilename', strings = { filename } },
                        '%=',
                        { hl = 'MiniStatuslineDevinfo',  strings = { lsp_clients } },
                        { hl = mode_hl,                  strings = { filetype, searchcount, loc } },
                    })
                end,

                inactive = function()
                    return MiniStatusline.combine_groups({
                        { hl = 'MiniStatuslineInactive', strings = { vim.fn.expand('%:t') } },
                    })
                end,
            },
        })
    end,
}
