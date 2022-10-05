local M = {}

function M.run(picker)
  local selected = picker:get_cursor_node()
  local input_opts = { prompt = "Rename to: ", default = selected:path(), completion = "file" }

  vim.ui.input(input_opts, function(new_file_path)
    vim.loop.fs_rename(selected:path(), new_file_path)
    picker:open(picker:current_node())
  end)

  vim.cmd("normal! :")
end

return M
