-- Zettelkasten: zk-nvim (lazy: ft)

require("pack").lazy({
	{
		src = "https://github.com/zk-org/zk-nvim",
		data = {
			lazy = {
				ft = "markdown",
			},
		},
	},
}, function()
	require("zk").setup({
		picker = "snacks_picker",
		lsp = {
			config = {
				name = "zk",
				cmd = { "zk", "lsp" },
				filetypes = { "markdown" },
			},
			auto_attach = { enabled = false },
		},
	})
end)
