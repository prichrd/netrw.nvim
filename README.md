# netrw.nvim

It's not because we use netrw that we cannot have nice things! This plugin adds
a layer of *✨bling✨* and configuration to your favorite file explorer.

<p align="center">
<img src="https://user-images.githubusercontent.com/3706527/203861361-2bead1ca-a8d2-46bf-b7ed-28ebc3b0589e.png">
</p>

## Features

- Print file icons in the sign column
- Configure custom actions with keybinds

## Requirements

- Neovim >= 0.5.0
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) (optional)
- [A patched font](https://www.nerdfonts.com/) (optional)

## Installing

Install the plugin with your preferred package manager:

[vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'prichrd/netrw.nvim'
```

[packer](https://github.com/wbthomason/packer.nvim)

```lua
use 'prichrd/netrw.nvim'
```

## Usage

Enable the plugin:

```lua
require'netrw'.setup{
  -- Put your configuration here, or leave the object empty to take the default
  -- configuration.
  icons = {
    symlink = '', -- Symlink icon (directory and file)
    directory = '', -- Directory icon
    file = '', -- File icon
  },
  use_devicons = true, -- Uses nvim-web-devicons if true, otherwise use the file icon specified above
  mappings = {}, -- Custom key mappings
}
```

Custom key mappings:

```lua
require'netrw'.setup{
  -- your config ...

  -- Define normal mode mapping
  mappings = {
    -- Function mappings
    ['p'] = function(payload)
      -- Payload is an object describing the node under the cursor, the object
      -- has the following keys:
      -- - dir: the current netrw directory (vim.b.netrw_curdir)
      -- - node: the name of the file or directory under the cursor
      -- - link: the referenced file if the node under the cursor is a symlink
      -- - extension: the file extension if the node under the cursor is a file
      -- - type: the type of node under the cursor (0 = dir, 1 = file, 2 = symlink)
      print(vim.inspect(payload))
    end,
    -- String command mappings
    ['<Leader><Tab>'] = ":echo 'string command'<CR>",
    -- more mappings ...
  }
  -- your config ...
}
```

The plugin documentation can be found at [doc/netrw.nvim.txt](doc/netrw.nvim.txt).
You can also use the :help netrw.nvim command inside of Neovim.

## Contributing

This project accepts contributions. Feel free to open issues for questions, feature ideas, bugs, etc.
Before submitting a PR, make sure you run `make lint` with `stylua` and `luacheck` installed.

