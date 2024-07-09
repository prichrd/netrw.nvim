local M = {}

M.TYPE_DIR = 0
M.TYPE_FILE = 1
M.TYPE_SYMLINK = 2
M.TYPE_MARKDOWNFILE = 3
M.TYPE_PDF = 4
M.TYPE_TXT = 5

---@alias Word {dir:string, node:string, link:string|nil, extension:string|nil, type:number, col:number}

---@param line string
---@param curdir string
---@return Word|nil
local parse_liststyle_0 = function(line, curdir)
	local _, _, node, link = string.find(line, "^(.+)@\t%s*%-%->%s*(.+)")
	if node then
		return {
			dir = curdir,
			col = 0,
			node = node,
			extension = vim.fn.fnamemodify(node, ":e"),
			link = link,
			type = M.TYPE_SYMLINK,
		}
	end

	local _, _, markdown = string.find(line, "^(.*)%.md")
	if markdown then
		return {
			dir = curdir,
			col = 0,
			node = markdown,
			type = M.TYPE_MARKDOWNFILE,
		}
	end

	local _, _, pdf = string.find(line, "^(.*)%.pdf")
	if pdf then
		return {
			dir = curdir,
			col = 0,
			node = pdf,
			type = M.TYPE_PDF,
		}
	end

	local _, _, txt = string.find(line, "^(.*)%.txt")
	if txt then
		return {
			dir = curdir,
			col = 0,
			node = txt,
			type = M.TYPE_TXT,
		}
	end

	local _, _, dir = string.find(line, "^(.*)/")
	if dir then
		return {
			dir = curdir,
			col = 0,
			node = dir,
			type = M.TYPE_DIR,
		}
	end

	local ext = vim.fn.fnamemodify(line, ":e")
	if string.sub(ext, -1) == "*" then
		ext = string.sub(ext, 1, -2)
		line = string.sub(line, 1, -2)
	end

	return {
		dir = curdir,
		col = 0,
		node = line,
		extension = ext,
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
			col = 0,
			node = node,
			extension = vim.fn.fnamemodify(node, ":e"),
			link = link,
			type = M.TYPE_SYMLINK,
		}
	end

	local _, _, markdown = string.find(line, "^(.*)%.md")
	if markdown then
		return {
			dir = curdir,
			col = 0,
			node = markdown,
			type = M.TYPE_MARKDOWNFILE,
		}
	end

	local _, _, pdf = string.find(line, "^(.*)%.pdf")
	if pdf then
		return {
			dir = curdir,
			col = 0,
			node = pdf,
			type = M.TYPE_PDF,
		}
	end

	local _, _, txt = string.find(line, "^(.*)%.txt")
	if txt then
		return {
			dir = curdir,
			col = 0,
			node = txt,
			type = M.TYPE_TXT,
		}
	end

	local _, _, dir = string.find(line, "^(.*)/")
	if dir then
		return {
			dir = curdir,
			col = 0,
			node = dir,
			type = M.TYPE_DIR,
		}
	end

	local file = vim.fn.substitute(line, "^\\(\\%(\\S\\+ \\)*\\S\\+\\).\\{-}$", "\\1", "e")
	local ext = vim.fn.fnamemodify(file, ":e")
	if string.sub(ext, -1) == "*" then
		ext = string.sub(ext, 1, -2)
		file = string.sub(file, 1, -2)
	end

	return {
		dir = curdir,
		col = 0,
		node = file,
		extension = ext,
		type = M.TYPE_FILE,
	}
end

---@param line string
---@param curdir string
---@return Word|nil
local parse_liststyle_3 = function(line, curdir)
	local _, to = string.find(line, "^[|%s]*")
	local pipelessLine = string.sub(line, to + 1, #line)

	if pipelessLine == "" then
		return nil
	end

	local _, _, node, link = string.find(pipelessLine, "^(.+)@\t%s*%-%->%s*(.+)")
	if node then
		return {
			dir = curdir,
			col = to,
			node = node,
			extension = vim.fn.fnamemodify(node, ":e"),
			link = link,
			type = M.TYPE_SYMLINK,
		}
	end

	local _, _, markdown = string.find(line, "^(.*)%.md")
	if markdown then
		return {
			dir = curdir,
			col = 0,
			node = markdown,
			type = M.TYPE_MARKDOWNFILE,
		}
	end

	local _, _, pdf = string.find(line, "^(.*)%.pdf")
	if pdf then
		return {
			dir = curdir,
			col = 0,
			node = pdf,
			type = M.TYPE_PDF,
		}
	end

	local _, _, txt = string.find(line, "^(.*)%.txt")
	if txt then
		return {
			dir = curdir,
			col = 0,
			node = txt,
			type = M.TYPE_TXT,
		}
	end

	local _, _, dir = string.find(pipelessLine, "^(.*)/")
	if dir then
		return {
			dir = curdir,
			col = to,
			node = dir,
			type = M.TYPE_DIR,
		}
	end

	local ext = vim.fn.fnamemodify(pipelessLine, ":e")
	if string.sub(ext, -1) == "*" then
		ext = string.sub(ext, 1, -2)
		pipelessLine = string.sub(pipelessLine, 1, -2)
	end

	return {
		dir = curdir,
		col = to,
		node = pipelessLine,
		extension = ext,
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
	elseif liststyle == 3 then
		return parse_liststyle_3(line, curdir)
	end

	return {}
end

return M
