local utils = require 'netrw.utils'

local Node = {}

function Node:new(path)
  -- TODO: Support symlinks
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o._name = utils.basename(path)
  o._path = path
  o._relpath = string.gsub(path, vim.loop.cwd() .. '/', '')
  o._stat = vim.loop.fs_stat(path)
  o._children = {}
  return o
end

function Node:type()
  if self._stat == nil then
    return ""
  end
  return self._stat.type
end

function Node:name()
  return self._name
end

function Node:path()
  return self._path
end

function Node:relpath()
  return self._relpath
end

function Node:children()
  return self._children
end

function Node:parent()
  -- TODO: Gracefully handle CWD expansion
  return Node:new(utils.parent_path(self._path))
end

function Node:scan_children()
  local handle = vim.loop.fs_scandir(self._path)
  local children = {}
  while true do
    local name, _ = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    local node = Node:new(self._path .. '/' .. name)
    -- TODO: Sort by type
    table.insert(children, node)
  end
  self._children = children
end

return Node
