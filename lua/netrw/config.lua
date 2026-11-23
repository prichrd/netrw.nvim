local M = {}

---@class Config
local defaults = {
	icons = {
		symlink = "",
		directory = "",
		file = "",
	},
	use_devicons = true,
	mappings = {},
}

---@type Config
M.options = {}

---@param options Config|nil
function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})

	local function render(bufnr)
		if
			vim.b[bufnr].netrw_liststyle ~= 0
			and vim.b[bufnr].netrw_liststyle ~= 1
			and vim.b[bufnr].netrw_liststyle ~= 3
		then
			return
		end

		-- Forces the usage of signcolumn in netrw buffers.
		vim.opt_local.signcolumn = "yes"

		require("netrw.ui").embelish(bufnr)
		require("netrw.actions").bind(bufnr)
	end

	local group = vim.api.nvim_create_augroup("netrw", { clear = false })

	if vim.version().minor >= 11 then
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "netrw",
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				vim.defer_fn(function()
					render(bufnr)
				end, 50)
			end,
			group = group,
		})
	else
		vim.api.nvim_create_autocmd("OptionSet", {
			pattern = "modified",
			callback = function()
				if not (vim.bo and vim.bo.filetype == "netrw") then
					return
				end
				render(vim.api.nvim_get_current_buf())
			end,
			group = group,
		})
	end
end

return M
