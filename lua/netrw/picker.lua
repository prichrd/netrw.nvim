local Picker = {}

local Pickers = {}

function Picker:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Picker:open(node)
  if node:type() == 'file' then
    vim.cmd(":e " .. node:relpath())
    self:teardown()
    return
  end
  self._node = node
  self._node:scan_children()
  if self._bufnr == nil then
    self:spawn()
  end
  self:render()
  self:register_keymaps()
end

function Picker:teardown()
  vim.api.nvim_buf_delete(self._bufnr, {force = true})
  table.remove(Pickers, self._bufnr)
end

function Picker:open_parent()
  self:open(self._node:parent())
end

function Picker:spawn()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
  vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(bufnr, "filetype", "netrw")
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

  -- TODO: Save window options to bring them back
  local winid = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(winid, bufnr)
  vim.api.nvim_win_set_option(winid, 'cursorline', true)
  vim.api.nvim_win_set_option(winid, 'cursorcolumn', false)
  vim.api.nvim_win_set_option(winid, 'number', false)
  vim.api.nvim_win_set_option(winid, 'relativenumber', false)

  -- TODO: Cleanup when quitting

  Pickers[bufnr] = self

  self._bufnr = bufnr
  self._winid = winid
end

function Picker:render()
  local lines = {}
  local children = self._node:children()
  for i = 1, #children do
    local child = children[i]

    -- TODO: Devicons if installed
    local icon = " "
    if child:type() == 'directory' then
      icon = ""
    elseif child:type() == 'file' then
      icon = ""
    end

    local suffix = ""
    if child:type() == 'directory' then
      suffix = "/"
    end

    lines[i] = " " .. icon .. " " .. child:name() .. suffix
  end
  vim.api.nvim_buf_set_option(self._bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(self._bufnr, 0, -1, true, lines)
  vim.api.nvim_buf_set_option(self._bufnr, "modifiable", false)
end

function Picker:register_keymaps()
  vim.api.nvim_buf_set_keymap(
    self._bufnr,
    "n",
    "<CR>",
    '<cmd>lua require("netrw.picker").callback(' .. self._bufnr .. ', "open")<CR>',
    { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    self._bufnr,
    "n",
    "<ESC><ESC>",
    '<cmd>lua require("netrw.picker").callback(' .. self._bufnr .. ', "quit")<CR>',
    { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    self._bufnr,
    "n",
    "-",
    '<cmd>lua require("netrw.picker").callback(' .. self._bufnr .. ', "open_parent")<CR>',
    { noremap = true }
  )
  -- TODO: Add create file action
  -- TODO: Add delete file action
  -- TODO: Add duplicate file action
end

function Picker:get_cursor_node()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(self._winid))
  local children = self._node:children()
  return children[row]
end

function Picker.callback(bufnr, action)
  local picker = Pickers[bufnr]
  if action == "open" then
    local selected = Pickers[bufnr]:get_cursor_node()
    picker:open(selected)
  elseif action == "open_parent" then
    picker:open_parent()
  elseif action == "quit" then
    picker:teardown()
  end
end

return Picker
