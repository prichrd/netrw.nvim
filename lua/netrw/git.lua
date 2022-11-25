local M = {}

M.FILE_ADDED = 0
M.FILE_CHANGED = 1
M.FILE_DELETED = 2

local parseStatus = function(statuses, lines)
  for _, line in ipairs(lines) do
    local s, path = string.match(line, '([^%s]*)%s*([^%s]*)')
    if path then
      if s == 'M' or s == 'MM' then
         statuses[path] = M.FILE_CHANGED
       elseif s == '??' then
         statuses[path] = M.FILE_ADDED
       end
     end
  end
end

M.status = function(path)
  local cwd = vim.fn.getcwd()
  local currdir = string.gsub(path, cwd.."/?", "", 1)
  local statuses = {}
  parseStatus(statuses, vim.fn.systemlist('git -C ' .. path .. ' status --porcelain'))

  local stats = {}
  for k, v in pairs(statuses) do
    if k:match('^'..currdir) then
      if currdir ~= '' then
        k = string.gsub(k, currdir..'/', '', 1)
      end
      local node = string.match(k, '^([%w%.]*)/?')
      if not stats[node] then
        stats[node] = {
          added = 0,
          changed = 0,
          deleted = 0,
        }
      end

      if v == M.FILE_ADDED then
        stats[node].added = stats[node].added + 1
      elseif v == M.FILE_CHANGED then
        stats[node].changed = stats[node].changed + 1
      elseif v == M.FILE_DELETED then
        stats[node].deleted = stats[node].deleted + 1
      end
    end
  end
  return stats
end

return M
