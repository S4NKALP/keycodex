-- put this in your main init.lua file ( before lazy setup )
vim.g.base46_cache = vim.fn.stdpath('data') .. '/base46_cache/'

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--single-branch',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
    return
end

local icons = require('lib.icons')
local plugins = require('plugins.list').plugins

lazy.setup({
    root = vim.fn.stdpath('data') .. '/lazy',
    defaults = { lazy = true },
    spec = plugins,
    lockfile = vim.fn.stdpath('config') .. '/lua/plugins/lock.json',
    concurrency = 8,
    dev = { path = '~/Projects/Github', patterns = { 'Projects' }, fallback = true },
    install = { missing = true, colorscheme = { 'nvchad' } },

    git = {
        log = { '--since=3 days ago' },
        timeout = 120,
        url_format = 'https://github.com/%s.git',
        filter = true,
    },

    ui = {
        size = { width = 0.9, height = 0.8 },
        wrap = true,
        border = 'rounded',
        icons = {
            cmd = icons.ui.Terminal,
            config = icons.ui.Gear,
            event = icons.ui.Electric,
            ft = icons.documents.File,
            init = icons.ui.Rocket,
            import = icons.documents.Import,
            keys = icons.ui.Keyboard,
            lazy = icons.ui.Sleep,
            loaded = icons.ui.CircleSmall,
            not_loaded = icons.ui.CircleSmallEmpty,
            plugin = icons.ui.Package,
            runtime = icons.ui.Neovim,
            source = icons.ui.Code,
            start = icons.ui.Play,
            task = icons.ui.Check,
            list = {
                icons.ui.CircleSmall,
                icons.ui.Arrow,
                icons.ui.Star,
                icons.ui.Minus,
            },
        },
        browser = nil,
        throttle = 20,
        custom_keys = {
            ['<localleader>l'] = function(plugin)
                require('lazy.util').float_term({ 'lazygit', 'log' }, {
                    cwd = plugin.dir,
                })
            end,

            ['<localleader>t'] = function(plugin)
                require('lazy.util').float_term(nil, {
                    cwd = plugin.dir,
                })
            end,
        },
    },

    diff = { cmd = 'git' },
    checker = { enabled = false, concurrency = nil, notify = true, frequency = 3600 },
    change_detection = { enabled = true, notify = true },
    performance = {
        cache = { enabled = true },
        reset_packpath = true,
        rtp = {
            reset = true,
            paths = {},
            disabled_plugins = {
                'gzip',
                'tarPlugin',
                'zipPlugin',
                'tohtml',
                -- 'tutor',
                -- 'matchit',
                -- 'matchparen',
                -- 'netrwPlugin',
            },
        },
    },
    readme = {
        root = vim.fn.stdpath('state') .. '/lazy/readme',
        files = { 'README.md', 'lua/**/README.md' },
        skip_if_doc_exists = true,
    },
    state = vim.fn.stdpath('state') .. '/lazy/state.json',
})

-- put this after lazy setup
-- Load base46 cache files if they exist
local function load_base46_cache()
    local cache_dir = vim.g.base46_cache

    -- Check if cache files exist, if not try to generate them
    if not vim.loop.fs_stat(cache_dir .. 'defaults') then
        pcall(function()
            require('base46').load_all_highlights()
        end)
    end

    -- Load cache files
    pcall(dofile, cache_dir .. 'defaults')
    pcall(dofile, cache_dir .. 'statusline')
end

load_base46_cache()
