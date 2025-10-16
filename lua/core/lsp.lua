--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------

-- ts_ls
vim.lsp.config('ts_ls', {
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
})
vim.lsp.enable('ts_ls')

-- rust
vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = true,
                experimental = { enable = true },
            },
        },
    },
})
vim.lsp.enable('rust_analyzer')

-- lua
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                disable = {
                    'missing-fields',
                    'undefined-global',
                },
            },
        },
    },
})
vim.lsp.enable('lua_ls')

-- python
vim.lsp.config('basedpyright', {
    settings = {
        basedpyright = {
            inlayHints = true,
            disableDiagnostics = true,
            disableOrganizeImports = true,
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                -- Enable diagnostics
                -- ignore = { "*" },
                diagnosticSeverityOverrides = {
                    reportUnusedImport = 'none',
                    reportUnusedVariable = 'none',
                    reportAttributeAccessIssue = 'none',
                    reportUnusedClass = 'none',
                    reportUnusedFunction = 'none',
                    reportDuplicateImport = 'none',
                    reportArgumentType = 'error',
                },
                typeCheckingMode = 'standard',
            },
        },
    },
})
vim.lsp.enable('basedpyright')

-- vim.lsp.config('pylsp', {
--     settings = {
--         pylsp = {
--             plugins = {
--                 -- use black as default formatter
--                 yapf = { enabled = false },
--                 autopep8 = { enabled = false },
--                 black = { enabled = true },
--                 pycodestyle = {
--                     enabled = true,
--                     ignore = { 'E203', 'E701', 'W503' },
--                     maxLineLength = 88,
--                 },
--             },
--         },
--     },
-- })

-- latex
vim.lsp.config('texlab', {
    settings = {
        texlab = {
            build = {
                executable = 'latexmk',
                args = {
                    '-lualatex',
                    '-interaction=nonstopmode',
                    '-outdir=build',
                },
                onSave = true,
            },
        },
    },
})
vim.lsp.enable('texlab')

-- bash
vim.lsp.config('bashls', {
    settings = {
        bashIde = {
            shellcheckArguments = {
                '--exclude=SC1090,SC1091,SC2076,SC2164',
            },
        },
    },
})
vim.lsp.enable('bashls')

-- cpp
vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--fallback-style=llvm',
        '--header-insertion=iwyu',
        '-j=4',
    },
})
vim.lsp.enable('clangd')
