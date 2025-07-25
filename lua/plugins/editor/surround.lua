local surround = require('mini.surround')

surround.setup({
    custom_surroundings = nil,
    mappings = {
        add = 'sa',
        delete = 'sd',
        find = 'sf',
        find_left = 'sF',
        highlight = 'sh',
        replace = 'sr',
        update_n_lines = 'sn',

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
    },

    -- How to search for surrounding
    -- 'cover', 'cover_or_next', 'cover_or_prev','cover_or_nearest', 'next', 'previous', 'nearest'.
    search_method = 'cover',
    highlight_duration = 300,
    n_lines = 20,
    respect_selection_type = false,
    silent = false,
})
