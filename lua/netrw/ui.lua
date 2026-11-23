local M = {}

local config = require("netrw.config")
local parse = require("netrw.parse")
local git = require("netrw.git")

local get_icon = function(node)
	local icon = ""
	local hl_group = ""

	if node.type == parse.TYPE_FILE then
		icon = config.options.icons.file
		if config.options.use_devicons then
			local has_miniicons, miniicons = pcall(require, "mini.icons")
			local has_devicons, devicons = pcall(require, "nvim-web-devicons")

			if has_miniicons then
				local ic, hi = miniicons.get("file", node.node)
				if ic then
					icon = ic
					hl_group = hi
				end
			elseif has_devicons then
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

---@return  string, string
---@param node Word
---@param git_status GitStatus
local status_from_node = function(node, git_status)
	local status = git_status[node.node]
	local sign
	local sign_hl
	if status.changed ~= 0 then
		sign = config.options.git.signs.changed
		sign_hl = config.options.git.hl.changed
	elseif status.added ~= 0 then
		sign = config.options.git.signs.added
		sign_hl = config.options.git.hl.added
	end

	if node.type == parse.TYPE_DIR then
		sign = config.options.git.signs.folder or sign
	end

	return sign, sign_hl
end

---@param bufnr number
M.embelish = function(bufnr)
	local namespace = vim.api.nvim_create_namespace("netrw")

	local curdir = vim.b.netrw_curdir
	local git_status = {}
	if config.options.git.enable then
		git_status = git.status(curdir)
	end

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

			if config.options.git.enable and git_status[node.node] then
				local sign, sign_hl = status_from_node(node, git_status)
				opts.virt_text = { { sign, sign_hl } }
				opts.virt_text_pos = "eol"
				opts.hl_mode = "combine"
			end

			vim.api.nvim_buf_set_extmark(bufnr, namespace, i - 1, 0, opts)
		else
			if hl_group then
				opts.virt_text = { { icon, hl_group } }
			else
				opts.virt_text = { { icon } }
			end

			-- FIXME: Wont show properly in tree view
			-- when the directory get expanded it won't show the git signs for
			-- the file outside of the collapsed directory (show only on current open directory)
			-- hint: git_status do only current directory, but need to do all
			-- directories and know the abs path for not colliding with same name files
			if config.options.git.enable and git_status[node.node] then
				local sign, sign_hl = status_from_node(node, git_status)
				opts.sign_text = sign
				opts.sign_hl_group = sign_hl
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
