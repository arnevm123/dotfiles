-- Kulala: HTTP/GraphQL/gRPC/WebSocket client

vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" })

require("kulala").setup({
	global_keymaps = true,
	global_keymaps_prefix = "<leader>k",
	kulala_keymaps = true,
	-- ponytail: kulala v6.16.2 omits these two keys from its defaults table, but
	-- string.lua reads them on every URL encode -> crashes every request parse.
	-- Supplying the documented defaults works around it. Remove if upstream fixes
	-- defaults.lua (keys: urlencode_skip/urlencode_force).
	urlencode_skip = "%[%]",
	urlencode_force = "%(%)",
})
