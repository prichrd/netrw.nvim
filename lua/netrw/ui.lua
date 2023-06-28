local M = {}

local config = require("netrw.config")
local parse = require("netrw.parse")

---@param bufnr number
M.embelish = function(bufnr)
	local namespace = vim.api.nvim_create_namespace("netrw")

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
					local ic, hi = devicons.get_icon(word.node, nil, { strict = true, default = false })
					if ic then
						opts.sign_hl_group = hi
						opts.sign_text = ic
					end
				end
			end
		elseif word.type == parse.TYPE_DIR then
			opts.sign_text = config.options.icons.directory
		elseif word.type == parse.TYPE_SYMLINK then
			opts.sign_text = config.options.icons.symlink
		end

		opts.sign_text = opts.sign_text

		vim.api.nvim_buf_set_extmark(bufnr, namespace, i - 1, 0, opts)
		::continue::
	end

	-- Fixes weird case where the cursor spawns inside of the sign column.
	vim.cmd([[norm lh]])
end

return M
