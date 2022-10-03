local M = {}

function M.basename(path)
  local i = path:match("^.*()/")
  if not i then
    return path
  end
  return path:sub(i + 1, #path)
end

function M.parent_path(path)
  local i = path:match("^.*()/")
  if not i then
    return path
  end
  return path:sub(1, i - 1)
end

function M.get_current_buffer_path()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local filepath = vim.fn.fnamemodify(bufname, ":p:h")
  return filepath
end

return M
