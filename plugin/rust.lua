-- rustaceanvim owns the rust-analyzer client: it starts, restarts and
-- configures the server itself, adds the :Rust* commands and the LSP action
-- integrations. That is why `rust_analyzer` is neither in the lsp_server list
-- in lua/extensions.lua nor configured with vim.lsp.config in lua/lsp.lua.
--
-- The binary itself still comes from Mason (`rust-analyzer`), because this
-- machine has no rustup: Rust is the Arch package.

-- Must be set before the plugin loads.
vim.g.rustaceanvim = {
    server = {
        -- keep blink.cmp's completion capabilities, which vim.lsp.config('*')
        -- cannot inject into a client rustaceanvim starts itself
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        settings = {
            ['rust-analyzer'] = {
                diagnostics = {
                    enable = true,
                    experimental = { enable = true },
                },
            },
        },
    },
}

add({ 'mrcjkb/rustaceanvim' })
