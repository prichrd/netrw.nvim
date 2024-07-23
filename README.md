# netrw.nvim

It's not because we use netrw that we cannot have nice things! This plugin adds
a layer of *✨bling✨* and configuration to your favorite file explorer.

<p align="center">
<img width="706" alt="image" src="https://github.com/prichrd/netrw.nvim/assets/3706527/2d3ec6cd-9950-4f5f-98cc-de86d91291c2">
</p>

## Features

- Print file icons in the sign column
- Configure custom actions with keybinds

## Requirements

- Neovim >= 0.5.0
- One of the following icon provider plugin (optional):
    - [mini.icons](https://github.com/echasnovski/mini.icons)
    - [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [A patched font](https://www.nerdfonts.com/) (optional)

## Installing

Install the plugin with your preferred package manager:

<details>
<summary><a href="https://github.com/folke/lazy.nvim">lazy.nvim</a></summary>
<code>{ 'prichrd/netrw.nvim', opts = {} }</code>
</details>

<details>
<summary><a href="https://github.com/junegunn/vim-plug">vim-plug</a></summary>
<code>Plug 'prichrd/netrw.nvim'</code>
</details>

<details>
<summary><a href="https://github.com/wbthomason/packer.nvim">packer</a></summary>
<code>use 'prichrd/netrw.nvim'</code>
</details>

## Configuration

Enable the plugin with the default configuration:
```lua
require("netrw").setup({})
```

Or customize the options to fit your needs:
```lua
require("netrw").setup({
  -- File icons to use when `use_devicons` is false or if
  -- no icon is found for the given file type.
  icons = {
    symlink = '',
    directory = '',
    file = '',
  },
  -- Uses mini.icon or nvim-web-devicons if true, otherwise use the file icon specified above
  use_devicons = true,
  mappings = {
    -- Function mappings receive an object describing the node under the cursor
    ['p'] = function(payload) print(vim.inspect(payload)) end,
    -- String mappings are executed as vim commands
    ['<Leader>p'] = ":echo 'hello world'<CR>",
  },
})
```

## Contributing

This project accepts contributions. Feel free to open issues for questions, feature ideas, bugs, etc.
Before submitting a PR, make sure you run `make lint` with `stylua` and `luacheck` installed.

