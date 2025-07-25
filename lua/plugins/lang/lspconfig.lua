local lspconfig = require('lspconfig')
local icons = require('lib.icons').diagnostics

local auto_install = require('lib.util').get_user_config('auto_install', true)
local installed_servers = {}
if auto_install then
    installed_servers = require('plugins.list').lsp_servers
end

local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Function to load LSP config from separate files
local function load_lsp_config(server_name)
    local config_path = 'lsp.' .. server_name
    local ok, config = pcall(require, config_path)
    if ok then
        return config
    end
    return nil
end

local default_setup = function(server)
    -- Check if there's a separate config file for this server
    local custom_config = load_lsp_config(server)

    if custom_config then
        -- Use the custom configuration and add capabilities
        local config = vim.tbl_deep_extend('force', custom_config, {
            capabilities = capabilities,
        })
        lspconfig[server].setup(config)
    else
        lspconfig[server].setup({
            capabilities = capabilities,
        })
    end
end

require('mason-lspconfig').setup({
    ensure_installed = installed_servers,
    handlers = { default_setup },
})

-- Setup servers that don't come from Mason
-- Dart language server (comes with Dart SDK)
if vim.fn.executable('dart') == 1 then
    local dart_config = load_lsp_config('dartls')
    if dart_config then
        local config = vim.tbl_deep_extend('force', dart_config, {
            capabilities = capabilities,
        })
        lspconfig.dartls.setup(config)
    else
        lspconfig.dartls.setup({
            capabilities = capabilities,
        })
    end
end

local signs = { Error = icons.Error, Warn = icons.Warning, Hint = icons.Hint, Info = icons.Information }
vim.diagnostic.config({
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    virtual_text = true,
    float = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = signs.Error,
            [vim.diagnostic.severity.WARN] = signs.Warn,
            [vim.diagnostic.severity.INFO] = signs.Info,
            [vim.diagnostic.severity.HINT] = signs.Hint,
        },
    },
})
