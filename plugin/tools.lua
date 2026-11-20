add({
    'wakatime/vim-wakatime', --wakaTime coding time tracker
    'akinsho/toggleterm.nvim', --float terminal
    'sudo-tee/opencode.nvim',
})

require('opencode').setup({
    preferred_picker = 'snacks',
    default_global_keymaps = false,
    server = {
        timeout = 15,
    },
    keymap = {
        editor = {
            ['<leader>Oo'] = { 'toggle', desc = 'OpenCode: Toggle panel' },
            ['<leader>Oi'] = { 'open_input', desc = 'OpenCode: Open input' },
            ['<leader>On'] = { 'open_input_new_session', desc = 'OpenCode: New session' },
            ['<leader>Om'] = { 'configure_provider', desc = 'OpenCode: Switch model' },
            ['<leader>Ov'] = { 'configure_variant', desc = 'OpenCode: Choose variant' },
            ['<leader>Oa'] = { 'agent', 'select', desc = 'OpenCode: Switch agent' },
            ['<leader>Oe'] = { 'undo', desc = 'OpenCode: Edit last prompt' },
            ['<leader>Or'] = { 'redo', desc = 'OpenCode: Redo last prompt' },
            ['<leader>Os'] = { 'select_session', desc = 'OpenCode: Sessions' },
            ['<leader>Oh'] = { 'select_history', desc = 'OpenCode: Prompt history' },
            ['<leader>Od'] = { 'diff_open', desc = 'OpenCode: Review diff' },
            ['<leader>Of'] = { 'toggle_focus', desc = 'OpenCode: Toggle focus' },
            ['<leader>Oz'] = { 'toggle_zoom', desc = 'OpenCode: Toggle zoom' },
            ['<leader>Ox'] = { 'cancel', desc = 'OpenCode: Cancel request' },
            ['<leader>Oy'] = { 'add_visual_selection', mode = { 'v' }, desc = 'OpenCode: Add selection' },
            ['<leader>OY'] = { 'add_visual_selection_inline', mode = { 'v' }, desc = 'OpenCode: Add selection inline' },
        },
        input_window = {
            ['<M-p>'] = { 'configure_provider', mode = { 'n', 'i' }, desc = 'Switch model' },
            ['<M-R>'] = { 'configure_variant', mode = { 'n', 'i' }, desc = 'Choose variant' },
            ['<M-n>'] = { 'open_input_new_session', mode = { 'n', 'i' }, desc = 'New session' },
            ['<M-e>'] = { 'undo', mode = { 'n', 'i' }, desc = 'Edit last prompt' },
        },
    },
})

-- Upstream `toggle` focuses the input window in Normal mode (start_insert =
-- false). The `/`, `@`, `#` and `~` trigger maps in the input window are
-- Insert-mode only, so Normal mode swallowed them first (search, macro, word
-- search, case toggle). Open the panel in Insert mode again, and keep a
-- Normal-mode fallback for those trigger keys inside the input buffer.
local opencode_insert_until = 0

vim.keymap.set('n', '<leader>Oo', function()
    opencode_insert_until = vim.uv.now() + 5000
    vim.cmd('Opencode toggle')
end, { desc = 'OpenCode: Toggle panel' })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('OpencodeInputInsert', { clear = true }),
    callback = function(args)
        if vim.uv.now() > opencode_insert_until or vim.bo[args.buf].filetype ~= 'opencode' then
            return
        end
        opencode_insert_until = 0
        vim.schedule(function()
            if vim.api.nvim_get_current_buf() == args.buf and vim.fn.mode() ~= 'i' then
                vim.cmd('startinsert')
            end
        end)
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('OpencodeInputKeys', { clear = true }),
    pattern = 'opencode',
    callback = function(args)
        for _, key in ipairs({ '/', '@', '#', '~' }) do
            vim.keymap.set('n', key, 'i' .. key, {
                buffer = args.buf,
                remap = true,
                desc = 'OpenCode: type trigger key',
            })
        end
    end,
})

-- Alias :OpenCode -> :Opencode with full autocompletion support
local opencode_cmd = require('opencode.commands')
vim.api.nvim_create_user_command('OpenCode', opencode_cmd.execute_command_opts, {
    desc = 'OpenCode command alias',
    nargs = '*',
    range = true,
    complete = opencode_cmd.complete_command,
})

-- Keep the selected model when switching agent/mode.
-- OpenCode otherwise resolves the mode's configured model on every switch.
local opencode_state = require('opencode.state')

local function pin_model_across_modes(model)
    require('opencode.config_file')
        .get_opencode_agents()
        :and_then(function(agents)
            if opencode_state.current_model ~= model then
                return
            end
            local mode_model_map = {}
            for _, mode in ipairs(agents or {}) do
                mode_model_map[mode] = model
            end
            opencode_state.model.set_mode_model_map(mode_model_map)
        end)
        :catch(function() end)
end

opencode_state.store.subscribe('current_model', function(_, model)
    if model and model ~= '' then
        pin_model_across_modes(model)
    end
end)

require('toggleterm').setup({
    size = 10,
    open_mapping = false, -- <C-\> is Navigator; use <leader>t1 / <leader>t2
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = '2',
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
            border = 'Normal',
            background = 'Normal',
        },
    },
})
