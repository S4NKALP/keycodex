-- Native UI2: cmdline + messages (experimental in 0.12). Does not replace which-key.
pcall(function()
    require('vim._core.ui2').enable()
end)

require('pack_helper')
require('packui').setup()
require('keys')
require('options')
require('autocmd')
require('lsp')
