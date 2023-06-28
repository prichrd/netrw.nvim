local M = {}

M.TYPE_DIR = 0
M.TYPE_FILE = 1
M.TYPE_SYMLINK = 2

---@alias Word {dir:string, node:string, link:string|nil, extension:string|nil, type:number}

---@param line string
---@param curdir string
---@return Word|nil
local parse_liststyle_0 = function(line, curdir)
	local _, _, node, link = string.find(line, "^(.+)@\t%s*%-%->%s*(.+)")
	if node then
		return {
			dir = curdir,
			node = node,
			extension = vim.fn.fnamemodify(node, ":e"),
			link = link,
			type = M.TYPE_SYMLINK,
		}
	end

	local _, _, dir = string.find(line, "^(.*)/")
	if dir then
		return {
			dir = curdir,
			node = dir,
			type = M.TYPE_DIR,
		}
	end

	return {
		dir = curdir,
		node = line,
		extension = vim.fn.fnamemodify(line, ":e"),
		type = M.TYPE_FILE,
	}
end

---@param line string
---@param curdir string
---@return Word|nil
local parse_liststyle_1 = function(line, curdir)
	local _, _, node, link = string.find(line, "^(.+)@%s+")
	if node then
		return {
			dir = curdir,
			node = node,
			extension = vim.fn.fnamemodify(node, ":e"),
			link = link,
			type = M.TYPE_SYMLINK,
		}
	end

	local _, _, dir = string.find(line, "^(.*)/")
	if dir then
		return {
			dir = curdir,
			node = dir,
			type = M.TYPE_DIR,
		}
	end

	local file = vim.fn.substitute(line, "^\\(\\%(\\S\\+ \\)*\\S\\+\\).\\{-}$", "\\1", "e")
	return {
		dir = curdir,
		node = file,
		extension = vim.fn.fnamemodify(file, ":e"),
		type = M.TYPE_FILE,
	}
end

---@param line string
---@return Word|nil
M.get_node = function(line)
	if string.find(line, '^"') then
		return nil
	end

	-- When netrw is empty, there's one line in the buffer and it is empty.
	if line == "" then
		return nil
	end

	local curdir = vim.b.netrw_curdir
	local liststyle = vim.b.netrw_liststyle

	if liststyle == 0 then
		return parse_liststyle_0(line, curdir)
	elseif liststyle == 1 then
		return parse_liststyle_1(line, curdir)
	end

	return {}
end

return M
