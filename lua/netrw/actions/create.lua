local M = {}

function M.run(picker)
  vim.ui.input({ prompt = 'Enter filename: ' }, function(choice)
    local path = picker:current_node():relpath() .. '/' .. choice
    vim.loop.fs_open(path, 'w', 420)
    picker:set_previous_path(path)
    picker:open(picker:current_node())
  end)

  vim.cmd("normal! :")
end

return M
