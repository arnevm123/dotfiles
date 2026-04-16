-- Test: neotest (deferred)

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-neotest/neotest",
})
vim.pack.add({ "https://github.com/nvim-neotest/neotest-python" })
vim.pack.add({ "https://github.com/nvim-neotest/neotest-plenary" })
vim.pack.add({ "https://github.com/fredrikaverpil/neotest-golang" })
vim.pack.add({ "https://github.com/rouge8/neotest-rust" })

-- Build step for neotest-golang
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "neotest-golang" and (ev.data.kind == "install" or ev.data.kind == "update") then
			vim.system({ "go", "install", "gotest.tools/gotestsum@latest" })
		end
	end,
})

---@diagnostic disable-next-line: missing-fields
require("neotest").setup({
	quickfix = { enabled = true, open = false },
	diagnostic = {
		enabled = true,
		severity = 4,
	},
	adapters = {
		require("neotest-golang")({ runner = "gotestsum" }),
		require("neotest-plenary"),
		require("neotest-rust"),
	},
})

local keymap = vim.keymap.set
keymap("n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = "test Run File" })
keymap("n", "<leader>tn", "<cmd>lua require('neotest').run.run()<CR>", { desc = "test Run Nearest" })
keymap(
	"n",
	"<leader>tdn",
	"<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
	{ desc = "test Debug Nearest" }
)
keymap("n", "<leader>tl", "<cmd>lua require('neotest').run.run_last()<CR>", { desc = "test Run Last" })
keymap(
	"n",
	"<leader>tdl",
	"<cmd>lua require('neotest').run.run_last({strategy = 'dap'})<CR>",
	{ desc = "test Debug Last" }
)
keymap("n", "<leader>tt", "<cmd>lua require('neotest').summary.toggle()<CR>", { desc = "test Summary" })
