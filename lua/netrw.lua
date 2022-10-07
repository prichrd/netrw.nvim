local picker = require('netrw.picker')
local utils = require('netrw.utils')
local Node = require('netrw.node')

local M = {
  conf = {},
}

function M.open()
  local n = Node:new(utils.get_current_buffer_dir())
  local p = picker:new(M.conf)
  p:open(n)
end

DEFAULT_OPTS = {
  enable_icons = true,
}

function M.on_enter()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  local path 
  if bufname == "" then
    path = vim.loop.cwd()
  else
    path = vim.fn.expand(bufname)
  end

  local stats = vim.loop.fs_stat(path)
  if stats and stats.type == "directory" then
    vim.cmd("noautocmd cd " .. path)
    M.open()
  end
end

function M.setup(conf)
  vim.tbl_deep_extend("force", DEFAULT_OPTS, conf or {})
  M.conf = conf

  vim.cmd "silent! autocmd! FileExplorer *"
  vim.cmd "autocmd VimEnter * ++once silent! autocmd! FileExplorer *"
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  vim.schedule(function()
    M.on_enter()
  end)
end

return M
