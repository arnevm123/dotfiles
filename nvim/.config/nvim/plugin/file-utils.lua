vim.pack.add({ "https://github.com/wsdjeg/vim-fetch" }) -- :e file:80
vim.pack.add({ "https://github.com/lambdalisue/vim-suda" }) -- save with sudo
vim.pack.add({ "https://github.com/tpope/vim-eunuch" }) -- :Delete, :Move, :Copy, :Mkdir, etc.
vim.pack.add({ "https://github.com/tpope/vim-projectionist" }) -- :A to go to alternate file

vim.g.projectionist_heuristics = {
	["go.mod"] = {
		["*.go"] = {
			alternate = "{}_test.go",
			type = "source",
		},
		["*_test.go"] = {
			alternate = "{}.go",
			type = "test",
		},
	},
}

local map = require("keymaps").map
map("n", "<leader>ot", "<cmd>A<CR>", "Toggle alternate file")
