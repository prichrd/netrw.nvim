local M = {}

function M.run(picker)
  local selected = picker:get_cursor_node()

  vim.ui.input({prompt = 'Delete ' .. selected:name() .. ' (y/n): '}, function(v)
    if v ~= 'y' then
      return
    end
    if vim.loop.fs_unlink(selected:path()) then
      print(selected:name() .. ' deleted')
    else
      print(selected:name() .. ' was not deleted')
    end
    picker:open(picker:current_node())
  end)

  vim.cmd("normal! :")
end

return M
