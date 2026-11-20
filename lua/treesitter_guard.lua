-- Workaround for builtin highlighter race:
--   Error in decoration provider "range" (ns=nvim.treesitter.highlighter)
--   ... treesitter.lua: get_node_text: Index out of bounds
--
-- The highlighter may iterate a stale tree while an async re-parse is still
-- pending. Query predicates (#lua-match?, #eq?, ...) then call get_node_text()
-- on a node whose range is already past EOF (buffer shrank after the capture),
-- and nvim_buf_get_text() errors out. Highlighting is already corrected on the
-- next parse, so degrade to empty text instead of erroring on every redraw.

local ts = vim.treesitter
local orig_get_node_text = ts.get_node_text

function ts.get_node_text(node, source, opts)
    if type(source) ~= 'number' then
        return orig_get_node_text(node, source, opts)
    end

    local ok, text = pcall(orig_get_node_text, node, source, opts)

    if ok then
        return text
    end

    return ''
end
