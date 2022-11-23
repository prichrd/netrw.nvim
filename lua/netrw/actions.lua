local M = {}

local config = require('netrw.config')
local parse = require('netrw.parse')

---@param key string
M.dispatch = function(key)
  local bufnr = vim.api.nvim_get_current_buf()
  local winid = vim.api.nvim_get_current_win()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(winid))
  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)
  local payload = parse.get_node(line[1])
  config.options.mappings[key](payload)
end

---@param bufnr number
M.bind = function(bufnr)
  local opts = { noremap = true, silent = true }
  for k, _ in pairs(config.options.mappings) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', k, ':lua require"netrw.actions".dispatch("' .. k .. '")<cr>', opts)
  end
end

return M
