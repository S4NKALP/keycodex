return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        local wk = require('which-key')
        wk.setup({
            preset = 'helix',
            plugins = {
                marks = true,
                registers = true,
                spelling = {
                    enabled = true,
                    suggestions = 30,
                },
            },
            presets = {
                operators = true,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
            },
            icons = {
                breadcrumb = ' ',
                separator = ' ',
                group = '',
                keys = {
                    Space = ' ',
                },
                rules = false, -- enable auto icon rules
            },
            show_help = false,
            show_keys = true,
            triggers = {
                { '<auto>', mode = 'nvisoct' },
                { '<leader>', mode = { 'n', 'v' } },
            },
        })

        local normal_mappings = {
            mode = 'n',
            { '<leader>x', ':x<cr>', desc = ' Save and Quit' },

            -- { "<leader>a", group = " AI" },

            { '<leader>b', group = ' Buffer' },

            { '<leader>c', group = ' Code' },
            { '<leader>cF', ':retab<cr>', desc = 'Fix Tabs' },
            { '<leader>cd', ':RootDir<cr>', desc = 'Root Directory' },
            { '<leader>cf', ':lua vim.lsp.buf.format({async = true})<cr>', desc = 'Format File' },
            { '<leader>cg', ':Neogen<cr>', desc = 'Generate Docstring' },
            { '<leader>cl', '::g/^\\s*$/d<cr>', desc = 'Clean Empty Lines' },
            { '<leader>cm', ':MarkdownPreviewToggle<cr>', desc = 'Markdown Preview' },
            { '<leader>cq', ':lua Snacks.picker.qflist()<cr>', desc = 'Quickfix List' },

            { '<leader>e', group = ' Edit' },
            { '<leader>ea', ':b#<cr>', desc = 'Alternate File' },
            { '<leader>eC', group = 'Edit Configs' },
            {
                '<leader>ee',
                function()
                    local minifiles = require('mini.files')
                    minifiles.open(vim.api.nvim_buf_get_name(0), true)
                    minifiles.reveal_cwd()
                end,
                desc = 'Explore Tree',
            },
            { '<leader>eE', ':lua Snacks.explorer()<cr>', desc = 'File Explorer' },
            { '<leader>ef', 'gf', desc = 'File Under Cursor' },
            { '<leader>em', ':e README.md<cr>', desc = 'Readme' },
            { '<leader>en', ':enew<cr>', desc = 'New File' },
            { '<leader>er', ":lua require('snacks').rename.rename_file()<cr>", desc = 'Rename Current File' },

            { '<leader>f', group = ' Find' },
            { '<leader>fx', ':%bd|e#|bd#<cr>', desc = 'Close except current' },
            { '<leader>ff', ':lua Snacks.picker.files()<cr>', desc = 'Find Files' },
            { '<leader>fg', ':lua Snacks.picker.grep()<cr>', desc = 'Live Grep' },
            { '<leader>fp', ':lua Snacks.picker.projects()<cr>', desc = 'Projects' },
            {
                '<leader>ct',
                function()
                    local curr_path = vim.fn.expand('%:p')
                    Snacks.picker.todo_comments({
                        transform = function(item)
                            local item_path = vim.fn.fnamemodify(item.cwd .. '/' .. item.file, ':p')
                            return item_path == curr_path
                        end,
                    })
                end,
                desc = 'Search Todos in Current File',
            },
            { '<leader>fT', ':lua Snacks.picker.todo_comments()<cr>', desc = 'Search Todos' },
            { '<leader>fu', ':lua Snacks.picker.undo()<cr>', desc = 'Undotree' },

            { '<leader>g', group = ' Git' },
            { '<leader>gA', ':Gitsigns stage_buffer<cr>', desc = 'Stage Buffer' },
            { '<leader>gR', ':Gitsigns reset_buffer<cr>', desc = 'Reset Buffer' },
            { '<leader>ga', ':Gitsigns stage_hunk<cr>', desc = 'Stage Hunk' },
            { '<leader>gb', ":lua require('gitsigns').blame_line({full = true})<cr>", desc = 'Blame' },
            { '<leader>gB', ":lua require('snacks').git.blame_line()<cr>", desc = 'Detailed Blame' },
            { '<leader>gc', ':Gitignore<cr>', desc = 'Generate .gitignore' },
            { '<leader>gd', ':Gitsigns diffthis HEAD<cr>', desc = 'Git Diff' },
            { '<leader>gF', ':Git<cr>', desc = 'Fugitive Panel' },
            { '<leader>gi', ':Gitsigns preview_hunk<cr>', desc = 'Hunk Info' },
            { '<leader>gj', ':Gitsigns next_hunk<cr>', desc = 'Next Hunk' },
            { '<leader>gk', ':Gitsigns prev_hunk<cr>', desc = 'Prev Hunk' },
            { '<leader>gl', ':lua Snacks.picker.git_log()<cr>', desc = 'Checkout commit' },
            { '<leader>gr', ':Gitsigns reset_hunk<cr>', desc = 'Reset Hunk' },
            { '<leader>gs', ':lua Snacks.picker.git_status()<cr>', desc = 'Open changed file' },
            { '<leader>gu', ':Gitsigns undo_stage_hunk<cr>', desc = 'Undo Stage Hunk' },
            { '<leader>gv', ':Gitsigns select_hunk<cr>', desc = 'Select Hunk' },
            { '<leader>gw', ':lua require("snacks").gitbrowse()<cr>', desc = 'Git Browse' },
            { '<leader>gp', ':lua Snacks.picker.git_branches()<cr>', desc = 'Pick and Switch Git Branches' },

            { '<leader>gt', group = 'Toggle' },
            { '<leader>gtb', ':Gitsigns toggle_current_line_blame<cr>', desc = 'Blame' },
            { '<leader>gtd', ':Gitsigns toggle_deleted<cr>', desc = 'Deleted' },
            { '<leader>gtl', ':Gitsigns toggle_linehl<cr>', desc = 'Line HL' },
            { '<leader>gtn', ':Gitsigns toggle_numhl<cr>', desc = 'Number HL' },
            { '<leader>gts', ':Gitsigns toggle_signs<cr>', desc = 'Signs' },
            { '<leader>gtw', ':Gitsigns toggle_word_diff<cr>', desc = 'Word Diff' },

            { '<leader>i', group = ' Insert' },
            { '<leader>id', ":put =strftime('## %a, %d %b, %Y, %r')<cr>", desc = 'Date' },
            { '<leader>if', ":put =expand('%:t')<cr>", desc = 'File Name' },
            { '<leader>ip', ':put %<cr>', desc = 'Relative Path' },
            { '<leader>iP', ':put %:p<cr>', desc = 'Absolute Path' },
            { '<leader>it', ":put =strftime('## %r')<cr>", desc = 'Time' },

            { '<leader>l', group = ' LSP' },
            { '<leader>la', ':Lspsaga code_action<cr>', desc = 'Code Action' },
            { '<leader>ld', ':Lspsaga goto_definition<cr>', desc = 'Goto Definition' },
            { '<leader>lf', ':Lspsaga finder<cr>', desc = 'Finder' },
            { '<leader>lh', ':Lspsaga hover_doc<cr>', desc = 'Hover' },
            { '<leader>lI', ':LspInfo<cr>', desc = 'LSP Info' },
            { '<leader>lj', ':Lspsaga diagnostic_jump_next<cr>', desc = 'Next Diagnostic' },
            { '<leader>lk', ':Lspsaga diagnostic_jump_prev<cr>', desc = 'Prev Diagnostic' },
            { '<leader>lo', ':Lspsaga outline<cr>', desc = 'Outline' },
            { '<leader>lp', ':Lspsaga peek_definition<cr>', desc = 'Peek Definition' },
            { '<leader>lq', ':LspStop<cr>', desc = 'Stop LSP' },
            { '<leader>lQ', ':LspRestart<cr>', desc = 'Restart LSP' },
            { '<leader>lr', ':Lspsaga rename<cr>', desc = 'Rename' },
            { '<leader>lR', ':Lspsaga project_replace<cr>', desc = 'Replace' },
            { '<leader>lt', ':Lspsaga goto_type_definition<cr>', desc = 'Goto Type Definition' },
            { '<leader>lT', ':Lspsaga peek_type_definition<cr>', desc = 'Peek Type Definition' },

            { '<leader>o', group = ' Options' },
            { '<leader>oi', 'vim.show_pos', desc = 'Inspect Position' },
            { '<leader>oN', ':lua Snacks.notifier.show_history()<cr>', desc = 'Notification History' },
            { '<leader>or', ':set relativenumber!<cr>', desc = 'Relative Numbers' },

            { '<leader>p', group = ' Packages' },
            { '<leader>pc', ':Lazy check<cr>', desc = 'Check' },
            { '<leader>pd', ':Lazy debug<cr>', desc = 'Debug' },
            { '<leader>pe', ':lua require("snacks").profiler.scratch()<cr>', desc = 'Profiler Scratch' },
            { '<leader>pf', ':lua require("snacks").profiler.pick()<cr>', desc = 'Profiler Pick' },
            { '<leader>pi', ':Lazy install<cr>', desc = 'Install' },
            { '<leader>pl', ':Lazy log<cr>', desc = 'Log' },
            { '<leader>pm', ':Mason<cr>', desc = 'Mason' },
            { '<leader>pp', ':Lazy<cr>', desc = 'Plugins' },
            { '<leader>pP', ':Lazy profile<cr>', desc = 'Profile' },
            { '<leader>pr', ':Lazy restore<cr>', desc = 'Restore' },
            { '<leader>ps', ':Lazy sync<cr>', desc = 'Sync' },
            { '<leader>pt', ':lua require("snacks").profiler.toggle()<cr>', desc = 'Profiler Toggle' },
            { '<leader>pu', ':Lazy update<cr>', desc = 'Update' },
            { '<leader>px', ':Lazy clean<cr>', desc = 'Clean' },

            { '<leader>q', group = ' Quit' },
            { '<leader>qa', ':qall<cr>', desc = 'Quit All' },
            { '<leader>qb', ':bw<cr>', desc = 'Close Buffer' },
            { '<leader>qd', ':lua require("snacks").bufdelete()<cr>', desc = 'Delete Buffer' },
            { '<leader>qf', ':qall!<cr>', desc = 'Force Quit' },
            { '<leader>qo', ':%bdelete|b#|bdelete#<cr>', desc = 'Close Others' },
            { '<leader>qq', ':q<cr>', desc = 'Quit' },
            { '<leader>qs', '<C-w>c', desc = 'Close Split' },
            { '<leader>qw', ':wq<cr>', desc = 'Write and Quit' },

            { '<leader>r', group = ' Refactor' },
            { '<leader>rd', '', desc = 'Go To Definition' }, -- treesitter navigation
            { '<leader>rD', '', desc = 'List Definition' },
            { '<leader>rh', '', desc = 'List Definition Head' },
            { '<leader>rj', '', desc = 'Next Usage' },
            { '<leader>rk', '', desc = 'Previous Usage' },
            { '<leader>rn', '', desc = 'Swap Next' },
            { '<leader>rp', '', desc = 'Swap Previous' },
            { '<leader>rr', '', desc = 'Smart Rename' },
            { '<leader>rs', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', desc = 'Replace Word Buffer' },

            { '<leader>s', group = ' Split' },
            { '<leader>s+', ':resize +10<cr>', desc = 'Increase window height' },
            { '<leader>s-', ':vertical resize -20<cr>', desc = 'Decrease window width' },
            { '<leader>s/', '<C-w>s', desc = 'Split Below' },
            { '<leader>s=', ':vertical resize +20<cr>', desc = 'Increase window width' },
            { '<leader>sH', ':vertical resize -10<cr>', desc = 'Decrease window width' },
            { '<leader>sJ', ':resize -5<cr>', desc = 'Decrease window height' },
            { '<leader>sK', ':resize +5<cr>', desc = 'Increase window height' },
            { '<leader>sL', ':vertical resize +10<cr>', desc = 'Increase window width' },
            { '<leader>s\\', '<C-w>v', desc = 'Split Right' },
            { '<leader>s_', ':resize -10<cr>', desc = 'Decrease window height' },
            { '<leader>s`', '<C-w>p', desc = 'Previous Window' },
            { '<leader>sa', ':split<cr>', desc = 'Horizontal Split' },
            { '<leader>sc', ':tabclose<cr>', desc = 'Close Tab' },
            { '<leader>sf', ':tabfirst<cr>', desc = 'First Tab' },
            { '<leader>sh', '<C-w>h', desc = 'Move Left' },
            { '<leader>sj', '<C-w>j', desc = 'Move Down' },
            { '<leader>sk', '<C-w>k', desc = 'Move Up' },
            { '<leader>sl', '<C-w>l', desc = 'Move Right' },
            { '<leader>sq', '<C-w>c', desc = 'Close Split' },
            { '<leader>ss', ':vsplit<cr>', desc = 'Vertical Split' },

            { '<leader>t', group = ' Terminal' },
            { '<leader>t1', '<cmd>1ToggleTerm<cr>', desc = 'Toggle Terminal' },
            { '<leader>t2', '<cmd>2ToggleTerm<cr>', desc = 'Toggle Terminal' },
            { '<leader>tc', '<Cmd>close<CR>', desc = 'Hide Terminal' },
            { '<leader>th', group = 'Inlay Hints' },

            { '<leader>w', group = ' Writing' },
            { '<leader>wc', ':set spell!<cr>', desc = 'Spellcheck' },
            { '<leader>wd', ':lua require("snacks").dim.enable()<cr>', desc = 'Dim On' },
            { '<leader>wD', ':lua require("snacks").dim.disable()<cr>', desc = 'Dim Off' },
            { '<leader>wf', ":lua require'utils'.sudo_write()<cr>", desc = 'Force Write' },
            { '<leader>wj', ']s', desc = 'Next Misspell' },
            { '<leader>wk', '[s', desc = 'Prev Misspell' },
            { '<leader>wn', ':WriteNoFormat<cr>', desc = 'Write Without Formatting' },
            { '<leader>wq', ':wq<cr>', desc = 'Write and Quit' },
            { '<leader>ww', ':w<cr>', desc = 'Write' },
            { '<leader>wz', ':lua require("snacks").zen.zen()<cr>', desc = 'Zen' },
            { '<leader>wZ', ':lua require("snacks").zen.zoom()<cr>', desc = 'Zoom' },

            { '<leader>y', group = ' Yank' },
            { '<leader>yL', ':CopyAbsolutePathWithLine<cr>', desc = 'Absolute Path with Line' },
            { '<leader>yP', ':CopyAbsolutePath<cr>', desc = 'Absolute Path' },
            { '<leader>ya', ':%y+<cr>', desc = 'Copy Whole File' },
            { '<leader>yf', ':CopyFileName<cr>', desc = 'File Name' },
            { '<leader>yg', ':lua require"gitlinker".get_buf_range_url()<cr>', desc = 'Copy Git URL' },
            { '<leader>yl', ':CopyRelativePathWithLine<cr>', desc = 'Relative Path with Line' },
            { '<leader>yp', ':CopyRelativePath<cr>', desc = 'Relative Path' },
        }

        local visual_mappings = {
            mode = 'v',
            -- { "<leader>a", group = " AI" },

            { '<leader>c', group = ' Code' },
            { '<leader>cS', ':sort!<cr>', desc = 'Sort Desc' },
            { '<leader>ci', ':sort i<cr>', desc = 'Sort Case Insensitive' },
            { '<leader>cs', ':sort<cr>', desc = 'Sort Asc' },
            { '<leader>cu', ':!uniq<cr>', desc = 'Unique' },
            { '<leader>cx', ':lua<cr>', desc = 'Execute Lua' },

            { '<leader>g', group = ' Git' },
            { '<leader>ga', ":'<,'>Gitsigns stage_hunk<cr>", desc = 'Stage Hunk' },
            { '<leader>gr', ":'<,'>Gitsigns reset_hunk<cr>", desc = 'Reset Hunk' },
            { '<leader>gu', ":'<,'>Gitsigns undo_stage_hunk<cr>", desc = 'Undo Stage Hunk' },

            { '<leader>l', group = ' LSP' },
            { '<leader>la', ':<C-U>Lspsaga range_code_action<cr>', desc = 'Code Action' },

            { '<leader>o', group = ' Options' },
            { '<leader>oc', ':CodeSnap<cr>', desc = 'CodeSnap into clipboard' },
            { '<leader>oC', ':CodeSnapSave<cr>', desc = 'CodeSnap in ~/Pictures' },

            { '<leader>y', group = ' Yank' },
            { '<leader>yg', ':lua require"gitlinker".get_buf_range_url("v")<cr>', desc = 'Copy Git URL' },
        }

        local no_leader_mappings = {
            mode = 'n',
            { '<C-Down>', ':resize -10<cr>', desc = 'Decrease window height' },
            { '<C-Left>', ':vertical resize -10<cr>', desc = 'Decrease window width' },
            { '<C-Right>', ':vertical resize +10<cr>', desc = 'Increase window width' },
            { '<C-Up>', ':resize +10<cr>', desc = 'Increase window height' },

            -- { '<S-h>', ':bprevious<cr>', desc = 'Previous Buffer' },
            -- { '<S-l>', ':bnext<cr>', desc = 'Next Buffer' },
            { '<Tab>', ':bnext<cr>', desc = 'Next Buffer' },
            { '<S-Tab>', ':bprevious<cr>', desc = 'Previous Buffer' },

            { 'K', ':Lspsaga hover_doc<cr>', desc = 'LSP Hover' },
            { 'Q', ':qall!<cr>', desc = 'Force Quit!' },
            { 'U', ':redo<cr>', desc = 'Redo' },

            { '[', group = ' Previous' },
            { '[g', ':Gitsigns prev_hunk<cr>', desc = 'Git Hunk' },
            { '[o', group = 'Textobjects' },

            { ']', group = ' Next' },
            { ']g', ':Gitsigns next_hunk<cr>', desc = 'Git Hunk' },
            { ']o', group = 'Textobjects' },

            { 'gd', ':Lspsaga goto_definition<cr>', desc = 'Goto Definition' },
        }

        wk.add(normal_mappings)
        wk.add(visual_mappings)
        wk.add(no_leader_mappings)
    end,
}
