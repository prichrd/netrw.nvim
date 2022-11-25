local M = {}

local config = require('netrw.config')
local parse = require('netrw.parse')
local git = require('netrw.git')

---@param bufnr number
M.embelish = function(bufnr)
  local namespace = vim.api.nvim_create_namespace('netrw')

  local curdir = vim.b.netrw_curdir

  local git_status = {}
  if config.options.use_git then
    git_status = git.status(curdir)
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    local word = parse.get_node(line)
    if not word then
      goto continue
    end

    local opts = {
      id = i,
    }

    if word.type == parse.TYPE_FILE then
      opts.sign_text = config.options.icons.file
      if config.options.use_devicons then
        local has_devicons, devicons = pcall(require, "nvim-web-devicons")
        if has_devicons then
          local ic, color = devicons.get_icon_color(word.node, word.extension)
          if ic then
            local hl_group = "FileIconColor" .. word.extension
            vim.api.nvim_set_hl(0, hl_group, { fg = color })
            opts.sign_hl_group = 'FileIconColor' .. word.extension
            opts.sign_text = ic
          end
        end
      end

      if config.options.use_git and git_status[word.node] then
        local gs = git_status[word.node]
        opts.virt_text_pos = 'eol'
        opts.hl_mode = 'combine'
        if gs.added ~= 0 then
          opts.virt_text = {{'+', 'GitGutterAdd'}}
        elseif gs.changed ~= 0 then
          opts.virt_text = {{'~', 'GitGutterChange'}}
        elseif gs.deleted ~= 0 then
          opts.virt_text = {{'-', 'GitGutterDelete'}}
        end
      end
    elseif word.type == parse.TYPE_DIR then
      opts.sign_text = config.options.icons.directory

      if config.options.use_git and git_status[word.node] then
        local gs = git_status[word.node]
        opts.virt_text_pos = 'eol'
        opts.hl_mode = 'combine'
        local virt_texts = {}
        if gs.added ~= 0 then
          table.insert(virt_texts, {gs.added .. '+', 'GitGutterAdd'})
        end
        if gs.changed ~= 0 then
          table.insert(virt_texts, {gs.changed .. '~', 'GitGutterChange'})
        end
        if gs.deleted ~= 0 then
          table.insert(virt_texts, {gs.deleted .. '-', 'GitGutterDelete'})
        end
        opts.virt_text = virt_texts
      end

    elseif word.type == parse.TYPE_SYMLINK then
      opts.sign_text = config.options.icons.symlink
    end

    opts.sign_text = opts.sign_text

    vim.api.nvim_buf_set_extmark(bufnr, namespace, i-1, 0, opts)
    ::continue::
  end

  -- Fixes weird case where the cursor spawns inside of the sign column.
  vim.cmd[[norm lh]]
end

return M
