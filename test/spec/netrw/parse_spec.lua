local parse = require("netrw.parse")
local curdir = "test/dir"

local testcases = {
	--
	-- liststyle 0
	--
	{
		liststyle = 0,
		line = "hello.txt",
		expected = {
			dir = curdir,
			node = "hello.txt",
			extension = "txt",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 0,
		line = "hello.test.js",
		expected = {
			dir = curdir,
			node = "hello.test.js",
			extension = "js",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 0,
		line = "README.md",
		expected = {
			dir = curdir,
			node = "README.md",
			extension = "md",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 0,
		line = ".gitignore",
		expected = {
			dir = curdir,
			node = ".gitignore",
			extension = "",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 0,
		line = "Makefile",
		expected = {
			dir = curdir,
			node = "Makefile",
			extension = "",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 0,
		line = "there are spaces.txt",
		expected = {
			dir = curdir,
			node = "there are spaces.txt",
			extension = "txt",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 0,
		line = ".git/",
		expected = {
			dir = curdir,
			node = ".git",
			type = parse.TYPE_DIR,
		},
	},
	{
		liststyle = 0,
		line = "hello2/",
		expected = {
			dir = curdir,
			node = "hello2",
			type = parse.TYPE_DIR,
		},
	},
	{
		liststyle = 0,
		line = "there 2 spaces/",
		expected = {
			dir = curdir,
			node = "there 2 spaces",
			type = parse.TYPE_DIR,
		},
	},
	{
		liststyle = 0,
		line = "symlink.txt@	 --> /some/place/other.txt",
		expected = {
			dir = curdir,
			node = "symlink.txt",
			extension = "txt",
			link = "/some/place/other.txt",
			type = parse.TYPE_SYMLINK,
		},
	},
	{
		liststyle = 0,
		line = "executable.exe*",
		expected = {
			dir = curdir,
			extension = "exe",
			node = "executable.exe",
			type = parse.TYPE_FILE,
		},
	},

	--
	-- liststyle 1
	--
	{
		liststyle = 1,
		line = ".git/                            0 Wed 28 Jun 17:20:58 2023",
		expected = {
			dir = curdir,
			node = ".git",
			type = parse.TYPE_DIR,
		},
	},
	{
		liststyle = 1,
		line = ".gitignore                       0 Wed 28 Jun 17:20:46 2023",
		expected = {
			dir = curdir,
			node = ".gitignore",
			extension = "",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 1,
		line = "Makefile                         0 Wed 28 Jun 17:21:13 2023",
		expected = {
			dir = curdir,
			node = "Makefile",
			extension = "",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 1,
		line = "README.md                        0 Wed 28 Jun 17:20:41 2023",
		expected = {
			dir = curdir,
			node = "README.md",
			extension = "md",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 1,
		line = "hello.test.js                    0 Wed 28 Jun 17:20:31 2023",
		expected = {
			dir = curdir,
			node = "hello.test.js",
			extension = "js",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 1,
		line = "hello2.txt                        0 Wed 28 Jun 17:20:27 2023",
		expected = {
			dir = curdir,
			node = "hello2.txt",
			extension = "txt",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 1,
		line = "there are 2 spaces.txt             0 Wed 28 Jun 17:21:37 2023",
		expected = {
			dir = curdir,
			node = "there are 2 spaces.txt",
			extension = "txt",
			type = parse.TYPE_FILE,
		},
	},
	{
		liststyle = 1,
		line = "there 2 spaces/                0 Wed 28 Jun 17:21:37 2023",
		expected = {
			dir = curdir,
			node = "there 2 spaces",
			type = parse.TYPE_DIR,
		},
	},
	{
		liststyle = 1,
		line = "todo.md@                         56 Mon 26 Jun 09:15:59 2023",
		expected = {
			dir = curdir,
			node = "todo.md",
			extension = "md",
			type = parse.TYPE_SYMLINK,
		},
		{
			liststyle = 1,
			line = "executable.exe*                 56 Mon 26 Jun 09:15:59 2023",
			expected = {
				dir = curdir,
				extension = "exe",
				node = "executable.exe",
				type = parse.TYPE_FILE,
			},
		},
	},
}

describe("parse", function()
	for _, test in pairs(testcases) do
		it("list style " .. test.liststyle .. ", should parse '" .. test.line .. "'", function()
			vim.b.netrw_liststyle = test.liststyle
			vim.b.netrw_curdir = curdir
			local result = parse.get_node(test.line)
			assert.are.same(test.expected, result)
		end)
	end
end)
