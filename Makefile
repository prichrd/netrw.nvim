all: lint

.PHONY: luacheck
luacheck:
	luacheck .

.PHONY: format
format:
	stylua .

.PHONY: stylua
stylua:
	stylua --check .

.PHONY: lint
lint: stylua luacheck

.PHONY: test
test:
	nvim --headless --noplugin -u test/minimal_init.lua -c "lua require(\"plenary.test_harness\").test_directory_command('test/spec {minimal_init = \"test/minimal_init.lua\"}')"
