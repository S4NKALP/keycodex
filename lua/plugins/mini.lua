return {
    'echasnovski/mini.nvim',
    config = function()
        require('mini.ai').setup() -- Extend and create a/i textobjects
        require('mini.pairs').setup() -- Autopairs
        require('mini.icons').setup() -- Icons
        require('mini.bracketed').setup() -- Go forward/backward with square brackets

        -- File explorer
        require('mini.files').setup({
            mappings = {
                close = 'q',
                go_in = 'L',
                go_in_plus = 'l',
                go_out = 'h',
                go_out_plus = 'H',
                mark_goto = "'",
                mark_set = 'm',
                reset = '<BS>',
                reveal_cwd = '@',
                show_help = 'g?',
                synchronize = '<CR>',
                trim_left = '<',
                trim_right = '>',
            },
        })

        require('mini.misc').setup({
            -- restore cursor position on file reopen
            require('mini.misc').setup_restore_cursor(),
            -- automated change of current directory
            require('mini.misc').setup_auto_root(),
        })

        -- splitjoin
        require('mini.splitjoin').setup({
            mappings = {
                toggle = '<leader>tj',
                split = '',
                join = '',
            },
        })

        -- surround action
        require('mini.surround').setup({
            mappings = {
                add = 'msa',
                delete = 'msd',
                find = 'msf',
                find_left = 'msF',
                highlight = 'msh',
                replace = 'msr',
                update_n_lines = 'msn',

                suffix_last = 'l',
                suffix_next = 'n',
            },
        })

        -- indents
        require('mini.indentscope').setup({
            draw = { animation = require('mini.indentscope').gen_animation.linear({ ease = 'out', duration = 15 }) },
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

        -- statusline
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
                        { hl = mode_hl, strings = { mode:upper() } },
                        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
                        '%<',
                        { hl = 'MiniStatuslineFilename', strings = { filename } },
                        '%=',
                        { hl = 'MiniStatuslineDevinfo', strings = { lsp_clients } },
                        { hl = mode_hl, strings = { filetype, searchcount, loc } },
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
