require('pack_helper')
require('packui').setup()
require('keys')
require('options')
require('autocmd')
require('lsp')

-- Disable expensive features during paste to avoid lag
do
    local function disable(buf)
        vim.b[buf]._paste_state = { lsp = vim.diagnostic.is_enabled(), mini = vim.b[buf].miniindentscope_disable }
        if vim.b[buf]._paste_state.lsp then vim.diagnostic.enable(false) end
        vim.b[buf].miniindentscope_disable = true
        vim.b[buf].ts_highlight_disable = true
        vim.b[buf].ts_indent_disable = true
    end

    local function enable(buf)
        local s = vim.b[buf]._paste_state
        if s then
            if s.lsp then vim.diagnostic.enable() end
            vim.b[buf].miniindentscope_disable = s.mini
        end
        vim.b[buf]._paste_state = nil
        vim.b[buf].ts_highlight_disable = nil
        vim.b[buf].ts_indent_disable = nil
    end

    local orig_paste = vim.paste
    vim.paste = function(lines, phase)
        if phase == 'start' then disable(vim.api.nvim_get_current_buf())
        elseif phase == 'finish' then vim.schedule(function() enable(vim.api.nvim_get_current_buf()) end) end
        return orig_paste(lines, phase)
    end

    local function perf_paste(cmd)
        return function()
            local buf = vim.api.nvim_get_current_buf()
            disable(buf)
            local reg = vim.v.register
            vim.cmd('normal! "' .. reg .. cmd)
            vim.schedule(function() enable(buf) end)
        end
    end

    vim.keymap.set('n', 'p', perf_paste('p=`]'), { desc = 'Paste and auto-indent' })
    vim.keymap.set('n', 'P', perf_paste('P=`]'), { desc = 'Paste before and auto-indent' })
end


