-- Test: neotest (deferred)

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-neotest/neotest",
})
vim.pack.add({ "https://github.com/nvim-neotest/neotest-python" })
vim.pack.add({ "https://github.com/nvim-neotest/neotest-plenary" })
vim.pack.add({
	{
		src = "https://github.com/fredrikaverpil/neotest-golang",
		data = { build = "go install gotest.tools/gotestsum@latest" },
	},
})
vim.pack.add({ "https://github.com/rouge8/neotest-rust" })

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

local map = require("keymaps").map
map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, "Test run file")
map("n", "<leader>tn", function() require("neotest").run.run() end, "Test run nearest")
map("n", "<leader>tdn", function() require("neotest").run.run({ strategy = "dap" }) end, "Test debug nearest")
map("n", "<leader>tl", function() require("neotest").run.run_last() end, "Test run last")
map("n", "<leader>tdl", function() require("neotest").run.run_last({ strategy = "dap" }) end, "Test debug last")
map("n", "<leader>tt", function() require("neotest").summary.toggle() end, "Test summary toggle")
