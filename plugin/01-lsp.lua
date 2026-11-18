add({
    'mason-org/mason.nvim', -- lsp installer manager
    'mason-org/mason-lspconfig.nvim', -- lsp installer
    'neovim/nvim-lspconfig', -- lsp config
})

require('mason').setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
        border = 'rounded',
        backdrop = 100,
    },
})

require('mason-lspconfig').setup({
    ensure_installed = require('extensions').lsp_server,
    automatic_installation = false, -- Don't auto-install or auto-configure
    -- Enable only what `vim.lsp.enable(require('extensions').lsp_server)` starts,
    -- so the list stays the single source of truth. Set true to also attach any
    -- Mason-installed server that nvim-lspconfig knows about (e.g. ruff, stylua).
    automatic_enable = false,
})
