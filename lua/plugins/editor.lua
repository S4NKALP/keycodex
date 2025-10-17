return {
    -- gitignore generator
    {
        "wintermute-cell/gitignore.nvim",
        cmd = { "Gitignore" },
        opts = {},
    },

    -- git signs
    {
        "lewis6991/gitsigns.nvim",
        events = { "BufReadPost", "BufNewFile" },
        opts = {
            signcolumn = true,
            current_line_blame = true,
            attach_to_untracked = false,
            watch_gitdir = {
                follow_files = true,
            },
            signs = {
                add = { text = " " },
                change = { text = "󱗜 " },
                delete = { text = "󰍵 " },
                topdelete = { text = "󱥨 " },
                changedelete = { text = "󰾟 " },
                untracked = { text = "󰰧 " },
            },
        },
    },

    -- Todo Comments
    {
        "folke/todo-comments.nvim",
        event = "BufRead",
        opts = {},
    },

    -- Working with file permissions
    {
        "lambdalisue/vim-suda",
        cmd = { "SudaRead", "SudaWrite" },
    },

    -- Undo tree
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" } },
    },

    -- visual multi
    {
        "mg979/vim-visual-multi",
        event = "VeryLazy",
        init = function()
            vim.g.VM_maps = {
                ["Find Under"] = "<M-d>",
                ["Find Subword Under"] = "<M-d>",
                ["Select All"] = "<C-M-d>",
                ["Add Cursor Down"] = "<C-M-j>",
                ["Add Cursor Up"] = "<C-M-k>",
            }
        end,
    },

    -- dimming the highlights of unused functions, variables, parameters, and more
    {
        "zbirenbaum/neodim",
        enabled = false,
        event = "LspAttach",
        config = function()
            require("neodim").setup({
                alpha = 0.5,
                blend_color = nil,
                hide = {
                    underline = true,
                    virtual_text = true,
                    signs = true,
                },
                regex = {
                    "[uU]nused",
                    "[nN]ever [rR]ead",
                    "[nN]ot [rR]ead",
                },
                priority = 128,
                disable = {},
            })
        end,
    },

    -- file operations
    {
        "chrisgrieser/nvim-genghis",
        keys = {
            {
                "<leader>fn",
                function()
                    require("genghis").createNewFile()
                end,
                desc = "New File",
            },
            {
                "<leader>fd",
                function()
                    require("genghis").duplicateFile()
                end,
                desc = "Duplicate File",
            },
            {
                "<leader>fr",
                function()
                    require("genghis").renameFile()
                end,
                desc = "Rename File",
            },
            {
                "<leader>fx",
                function()
                    require("genghis").chmodx()
                end,
                desc = "Make Executable",
            },
        },
    },

    -- Better folding
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = "BufReadPost",
        keys = {
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
            },
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
            },
            {
                "zr",
                function()
                    require("ufo").openFoldsExceptKinds()
                end,
            },
            {
                "zm",
                function()
                    require("ufo").closeFoldsWith()
                end,
            },
        },
        config = function()
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            require("ufo").setup({
                provider_selector = function()
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },

    -- rendering for html and markdown
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        -- to load before treesitter
        priority = 45,
        opts = {
            preview = {
                enable = false,
            },
        },
        keys = {
            { "<leader>cv", "<Cmd>Markview toggle<CR>", desc = "Toggle markdown preview", mode = "n" },
        },
    },

    -- markdown preview
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = "markdown",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview" },
    },
}
