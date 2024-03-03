local M = {}

local config = require("netrw.config")
local parse = require("netrw.parse")

local get_icon = function(node)
	local icon = ""
	local hl_group = ""

	if node.type == parse.TYPE_FILE then
		icon = config.options.icons.file
		if config.options.use_devicons then
			local has_devicons, devicons = pcall(require, "nvim-web-devicons")
			if has_devicons then
				local ic, hi = devicons.get_icon(node.node, nil, { strict = true, default = false })
				if ic then
					icon = ic
					hl_group = hi
				end
			end
		end
	elseif node.type == parse.TYPE_DIR then
		icon = config.options.icons.directory
	elseif node.type == parse.TYPE_SYMLINK then
		icon = config.options.icons.symlink
	end

	return { icon, hl_group }
end

---@param bufnr number
M.embelish = function(bufnr)
	local namespace = vim.api.nvim_create_namespace("netrw")

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		local node = parse.get_node(line)
		if not node then
			goto continue
		end

		local opts = { id = i }
		local icon, hl_group = unpack(get_icon(node))
		if node.col == 0 then
			if hl_group then
				opts.sign_hl_group = hl_group
			end
			opts.sign_text = icon
			vim.api.nvim_buf_set_extmark(bufnr, namespace, i - 1, 0, opts)
		else
			if hl_group then
				opts.virt_text = { { icon, hl_group } }
			else
				opts.virt_text = { { icon } }
			end
			opts.virt_text_pos = "overlay"
			vim.api.nvim_buf_set_extmark(bufnr, namespace, i - 1, node.col - 2, opts)
		end
		::continue::
	end

	-- Fixes weird case where the cursor spawns inside of the sign column.
	vim.cmd([[norm lh]])
end

return M
