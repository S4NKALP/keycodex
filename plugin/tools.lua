add({
    { src = 'iamcco/markdown-preview.nvim', build = 'cd app && npm install' },
    'wakatime/vim-wakatime', --wakaTime coding time tracker
    'akinsho/toggleterm.nvim', --float terminal
    'sudo-tee/opencode.nvim',
})

require('opencode').setup({
    preferred_picker = 'snacks',
    default_global_keymaps = false,
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
    open_mapping = [[<c-\>]],
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
