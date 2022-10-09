# netrw.nvim

**⚠️ This plugin is in an early development phase; I would not recommend using it. ⚠️**

This experimental Neovim plugin aims at providing the same functionality as the
regular netrw file explorer but with a bit more *bling*. This plugin is meant 
for enjoyers of the [vinegar](https://github.com/tpope/vim-vinegar) workflow
wanting to have something more configurable.

## Installation

netrw.nvim uses the standard package structure and can be installed using any
popular Neovim compatible package managers: 

* [vim-plug](https://github.com/junegunn/vim-plug)
  * `Plug 'prichrd/netrw.nvim'`
* [packer](https://github.com/wbthomason/packer.nvim)
  * `use 'prichrd/netrw.nvim'`

## Configuration

Once installed, the package requires needs to be initialized to function
properly. Call the setup function from your Neovim config:

```lua
require('netrw').setup{}
```

## Contributing

This is a small project that I am working on when I have time to spare, feel free 
to pick or raise issues from the [issue page](https://github.com/prichrd/netrw.nvim/issues), 
PRs are always welcome!
