--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------

-- Servers are enabled in one call at the end, from the list in `extensions.lua`.
-- That list is also what mason-lspconfig installs, so adding a server means
-- editing one file instead of touching this one.

vim.schedule(function()
    local servers = require('extensions').lsp_server

    vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
    })

    -- vtsls (TypeScript/JavaScript; drop-in for ts_ls)
    vim.lsp.config('vtsls', {
        settings = {
            -- use the TypeScript version pinned by the project when there is one
            vtsls = {
                autoUseWorkspaceTsdk = true,
            },
            typescript = {
                inlayHints = {
                    parameterNames = { enabled = 'all', suppressWhenArgumentMatchesName = false },
                    parameterTypes = { enabled = true },
                    variableTypes = { enabled = true },
                    propertyDeclarationTypes = { enabled = true },
                    functionLikeReturnTypes = { enabled = true },
                    enumMemberValues = { enabled = true },
                },
            },
        },
    })

    vim.lsp.config('tailwindcss', {
        filetypes = {
            'astro',
            'blade',
            'edge',
            'ejs',
            'erb',
            'gohtml',
            'gohtmltmpl',
            'handlebars',
            'hbs',
            'html',
            'jade',
            'leaf',
            'liquid',
            'markdown',
            'mdx',
            'mustache',
            'nunjucks',
            'php',
            'razor',
            'slim',
            'twig',
            'css',
            'less',
            'postcss',
            'sass',
            'scss',
            'stylus',
            'sugarss',
            'javascript',
            'javascriptreact',
            'rescript',
            'typescript',
            'typescriptreact',
            'vue',
            'svelte',
            'templ',
        },
    })

    -- rust
    vim.lsp.config('rust_analyzer', {
        settings = {
            ['rust-analyzer'] = {
                cargo = {
                    buildScripts = {
                        enable = true,
                    },
                },
                check = {
                    command = 'clippy',
                },
                procMacro = {
                    enable = true,
                },
                completion = {
                    autoimport = {
                        enable = true,
                    },
                },
                inlayHints = {
                    bindingModeHints = {
                        enable = true,
                    },
                    closureReturnTypeHints = {
                        enable = 'always',
                    },
                    lifetimeElisionHints = {
                        enable = 'always',
                    },
                    parameterHints = {
                        enable = true,
                    },
                    typeHints = {
                        enable = true,
                    },
                },
            },
        },
    })

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

    -- python
    vim.lsp.config('basedpyright', {
        settings = {
            basedpyright = {
                inlayHints = true,
                analysis = {
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
                    autoSearchPaths = true,
                },
            },
        },
    })

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

    -- cpp
    vim.lsp.config('clangd', {
        cmd = {
            'clangd',
            '--fallback-style=llvm',
            '--header-insertion=iwyu',
            '-j=4',
        },
    })

    vim.lsp.config('gopls', {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        },
    })

    -- html, cssls and every other server above start from this single call
    vim.lsp.enable(servers)
end)
