require('core.options')
require('core.functions')
require('core.keys')
require('core.autocmd')
require('plugins.lazy')
-- Add user configs to this module
pcall(require, 'user')

-- load theme
dofile(vim.g.base46_cache .. 'defaults')
dofile(vim.g.base46_cache .. 'statusline')

-- Run pywal chadwal script silently in background
os.execute('python3 ~/.config/nvim/pywal/chadwal.py &> /dev/null &')
