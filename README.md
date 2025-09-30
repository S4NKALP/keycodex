<center>

<h1>
  <a href="https://S4NKALP.github.io/keycodex">keycodex</a>
</h1>

<!-- Badges -->
<p>
  <a href="https://github.com/S4NKALP/keycodex/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/S4NKALP/keycodex?style=flat&color=eee">
  </a>
  <a href="https://github.com/S4NKALP/keycodex/graphs/contributors">
    <img alt="People" src="https://img.shields.io/github/contributors/S4NKALP/keycodex?style=flat&color=ffaaf2&label=People">
  </a>
  <a href="https://github.com/S4NKALP/keycodex/stargazers">
    <img alt="Stars" src="https://img.shields.io/github/stars/S4NKALP/keycodex?style=flat&color=98c379&label=Stars">
  </a>
  <a href="https://github.com/S4NKALP/keycodex/network/members">
    <img alt="Forks" src="https://img.shields.io/github/forks/S4NKALP/keycodex?style=flat&color=66a8e0&label=Forks">
  </a>
  <a href="https://github.com/S4NKALP/keycodex/watchers">
    <img alt="Watches" src="https://img.shields.io/github/watchers/S4NKALP/keycodex?style=flat&color=f5d08b&label=Watches">
  </a>
  <a href="https://github.com/S4NKALP/keycodex/pulse">
    <img alt="Last Updated" src="https://img.shields.io/github/last-commit/S4NKALP/keycodex?style=flat&color=e06c75">
  </a>
</p>

<h3>My Personalized Dev Env ❤️👨‍💻</h3>

<!-- Screenshot -->
<figure>
  <img src="assets/screenshot.png" alt="keycodex screenshot" style="max-width: 100%; height: auto;">
  <figcaption>keycodex screenshot</figcaption>
</figure>

<p>Handcrafted Neovim setup for the ultimate CLI dev experience</p>

</center>

## 💻 Installation

```bash
git clone https://github.com/S4NKALP/keycodex ~/.config/nvim
```

## 🚀 Usage

### Core

Files in [lua/core](./lua/core/) control the core of neovim:

- [options](./lua/core/options.lua),
- [functions](./lua/core/functions.lua)
- [autocmds](./lua/core/autocmd.lua)

### ⌨️ Keybindings

Apart from [core/keys](./lua/core/keys.lua) most keybindings are configured using [which-key](./lua/plugins/whichkey.lua)
