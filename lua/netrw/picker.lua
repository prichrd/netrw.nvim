local Picker = {}

local utils = require 'netrw.utils'

local Pickers = {}

function Picker:new(conf)
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.conf = conf
  return o
end

function Picker:open(node)
  if self._previous_path == nil then
    self._previous_path = utils.get_current_buffer_path()
  end
  vim.cmd(":e " .. node:relpath())
  if node:type() == 'file' then
    self:teardown()
    return
  end
  self._node = node
  self._node:scan_children()
  self:spawn()
  self:render()
  self:register_keymaps()
end

function Picker:open_parent()
  self._previous_path = self._node:path()
  self:open(self._node:parent())
end

function Picker:spawn()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
  vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(bufnr, "filetype", "netrw")
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

  local winid = vim.api.nvim_get_current_win()
  -- Backup window configs to bring them back up at teardown.
  self._win_options = {
    cursorline = vim.api.nvim_win_get_option(winid, 'cursorline'),
    cursorcolumn = vim.api.nvim_win_get_option(winid, 'cursorcolumn'),
    number = vim.api.nvim_win_get_option(winid, 'number'),
    relativenumber = vim.api.nvim_win_get_option(winid, 'relativenumber'),
  }

  vim.api.nvim_win_set_buf(winid, bufnr)
  vim.api.nvim_win_set_option(winid, 'cursorline', true)
  vim.api.nvim_win_set_option(winid, 'cursorcolumn', false)
  vim.api.nvim_win_set_option(winid, 'number', false)
  vim.api.nvim_win_set_option(winid, 'relativenumber', false)

  Pickers[bufnr] = self

  self._bufnr = bufnr
  self._winid = winid
end

function Picker:teardown()
  -- Bring back initial window configuration.
  vim.api.nvim_win_set_option(self._winid, 'cursorline', self._win_options.cursorline)
  vim.api.nvim_win_set_option(self._winid, 'cursorcolumn', self._win_options.cursorcolumn)
  vim.api.nvim_win_set_option(self._winid, 'number', self._win_options.number)
  vim.api.nvim_win_set_option(self._winid, 'relativenumber', self._win_options.relativenumber)
  vim.api.nvim_buf_delete(self._bufnr, { force = true })
  table.remove(Pickers, self._bufnr)
end

function Picker:render()
  local lines = {}
  local children = self._node:children()
  local gt = 0
  for i = 1, #children do
    local child = children[i]
    if child:path() == self._previous_path then
      gt = i
    end

    local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
    local icon = ''
    if self.conf.enable_icons then
      if child:type() == 'directory' then
        icon = " "
      elseif child:type() == 'file' then
        icon = " "
        if has_devicons then
          local ic = devicons.get_icon(child:name())
          if ic ~= nil then
            icon = ic .. " "
          end
        end
      end
    end

    local suffix = ""
    if child:type() == 'directory' then
      suffix = "/"
    end

    lines[i] = " " .. icon .. child:name() .. suffix
  end
  vim.api.nvim_buf_set_option(self._bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(self._bufnr, 0, -1, true, lines)
  if gt ~= nil then
    vim.cmd(":" .. gt)
  end
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
