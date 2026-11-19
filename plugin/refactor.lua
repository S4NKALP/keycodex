add({
    -- core `vim.async` only lands in 0.13; on 0.12 the plugin falls back to this
    'lewis6991/async.nvim',
    'ThePrimeagen/refactoring.nvim',
})

require('refactoring').setup({})

-- One key talks to all four refactors: inline variable, extract variable,
-- inline function, extract function. `select_refactor` reads the current mode
-- itself, so normal mode acts on the cursor and visual mode on the selection.
-- The list is answered by the snacks picker (see plugin/snacks.lua).
vim.keymap.set({ 'n', 'x' }, '<leader>rf', function()
    require('refactoring').select_refactor()
end, { desc = 'Refactor (pick)' })
