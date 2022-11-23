local M = {}

---@class Config
local defaults = {
  icons = {
    symlink = '',
    directory = '',
    file = '',
  },
  use_devicons = true,
  mappings = {},
}

---@type Config
M.options = {}

---@param options Config|nil
function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})

  -- Hook on BufModifiedSet to configure the netrw buffer.
  vim.api.nvim_create_autocmd('BufModifiedSet', {
    pattern = {"*"},
    callback = function()
      if not (vim.bo and vim.bo.filetype == 'netrw') then
        return
      end

      if vim.b.netrw_liststyle ~= 0 then
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      require'netrw.ui'.embelish(bufnr)
      require'netrw.actions'.bind(bufnr)
    end,
    group = vim.api.nvim_create_augroup("netrw", {clear = false}),
  })
end

return M
