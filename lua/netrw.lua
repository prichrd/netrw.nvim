local picker = require('netrw.picker')
local utils = require('netrw.utils')
local Node = require('netrw.node')

local M = {}

function M.open()
  local n = Node:new(utils.get_current_buffer_dir())
  local p = picker:new()
  p:open(n)
end

return M
