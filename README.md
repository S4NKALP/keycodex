<div align = "center">

<h1><a href="https://S4NKALP.github.io/keycodex">keycodex</a></h1>

<h3>Your Personalized Dev Env ❤️👨‍💻</h3>

</div>

Handcrafted Neovim setup for the ultimate CLI dev experience.

## ✨ Features

- **Fully configured LSP**: Out of the box LSP and completions, including Copilot (optional)
- **Awesome keybindings**: Intuitive and well documented keybindings with which-key
- **Blazingly fast**: Starts up in less than 30ms thanks to extensive lazy loading
- **Batteries included**: Has all the necessary plugins included out of the box
- **Git in there**: Powerful git integrations thanks to lazygit, fugitive, gitsigns and more
- **Pretty colors**: Comes with treesitter and onedark preconfigured with full transparency support
- **Tmux integration**: Works with your tmux configurations out of the box
- **Dev tools**: Comes with debugging, testing, database and REPL support, pick and choose
- **Auto install**: All necessary LSPs, Formatter, Linters, Treesitter Parsers etc. are auto installed
- **User module**: Configure keycodex according to your needs by using the `user` module!
- and some more

Most importantly:

**Built for extending**: keycodex has a easy to understand config structure that promotes personalization, so go ahead, bring your keybindings, functions and plugins over, and truly make **keycodex: Your Personalized Development Environment!**

## ⚡ Setup

### ⚙️ Requirements

Before you begin, ensure you have met the following requirements:

- You have installed the latest version of `neovim`
- Some command line tools: fd, ripgrep

### 💻 Installation

To install `keycodex` clone the repo and setup the symlink

```bash
git clone https://github.com/S4NKALP/keycodex
```

On Linux and Mac

```bash
ln -sfnv $PWD/keycodex $HOME/.config/nvim
```

On Windows Powershell

```powershell
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$PWD\keycodex" -Force
```

## 🚀 Usage

### 🎨 User Configs

`keycodex` supports a user module where you can store your custom configs and override any default configs.

To use custom configs create the file `lua/user/init.lua` in keycodex, with the following structure:

```lua
-- lua/user/init.lua
local user = {
    auto_install = true, -- enable auto install of LSPs, Treesitter parsers etc.
    user_lsp_servers = {
        -- Auto installed LSPs defined by user
    },
    user_formatter_sources = {
        -- Auto installed formatter sources defined by user
    },
    user_linter_sources = {
        -- Auto installed lintere sources defined by user
    },
    user_treesitter_parsers = {
        -- Auto installed Treesitter parsers defined by user
    },

    enable_db_explorer = false, -- enable dbee.nvim support
    enable_debugger = false, -- enable dap.nvim support
    enable_test_runner = false, -- enable neotest.nvim support
    enable_trainer = false, -- enable hardtime.nvim support
    user_plugins = {
        -- Add your lazy plugin spec here
    },

    user_keybindings = {
        -- Add your which-key bindings here
    }
}

return user
```

You can add and `require` any other custom modules and configurations you want in this file.

`user` module is not part of the repo, you can set up `user` module as a separate git repository while continuing to receive `keycodex` updates.

### Core

Files in [lua/core](./lua/core/) control the core of neovim:

- [options](./lua/core/options.lua),
- [functions](./lua/core/functions.lua)
- [autocmds](./lua/core/autocmd.lua)
- [core keybindings](./lua/core/keys.lua)

### ⌨️ Keybindings

Apart from [core/keys](./lua/core/keys.lua) most keybindings are configured using [which-key](./lua/plugins/tools/which-key.lua)

### 📦 Plugins

You can check out the [plugins list file](./lua/plugins/list.lua) file to see the plugins that are included in keycodex.

- [lang](./lua/plugins/lang/): Plugins related to language features, completions, lsp, editing etc.
- [tools](./lua/plugins/tools/): Plugins that add tool integrations to the editor.
- [ui](./lua/plugins/ui/): Plugins that make improve Neovim user experience.

## 🙏 Acknowledgments

This project builds upon [nvim2k](https://github.com/2KAbhishek/nvim2k) by [2KAbhishek](https://github.com/2KAbhishek/), enhancing it with additional features and optimizations.

