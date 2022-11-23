local M = {}

M.TYPE_DIR = 0
M.TYPE_FILE = 1
M.TYPE_SYMLINK = 2

---@alias Word {dir:string, node:string, link:string|nil, extension:string|nil, type:number}

---@param line string
---@return Word|nil
M.get_node = function(line)
  if string.find(line, '^"') then
    return nil
  end

  -- When netrw is empty, there's one line in the buffer and it is empty.
  if line == '' then
    return nil
  end

  local curdir = vim.b.netrw_curdir

  local _, _, node, link = string.find(line, "^(.+)@\t%s*%-%->%s*(.+)$")
  if node then
    return {
      dir = curdir,
      node = node,
      link = link,
      type = M.TYPE_SYMLINK,
    }
  end

  local _, _, dir = string.find(line, "^(.+)/$")
  if dir then
    return {
      dir = curdir,
      node = dir,
      type = M.TYPE_DIR,
    }
  end

  return {
    dir = curdir,
    node = line,
    extension = vim.fn.fnamemodify(line, ":e"),
    type = M.TYPE_FILE,
  }
end

return M
