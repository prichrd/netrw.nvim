all: lint

.PHONY: luacheck
luacheck:
	luacheck .

.PHONY: stylua
stylua:
	stylua --check .

.PHONY: lint
lint: stylua luacheck
