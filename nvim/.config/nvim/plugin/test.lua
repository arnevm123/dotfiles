-- Test: neotest (lazy: keys)

require("pack").lazy({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-neotest/nvim-nio",
	{
		src = "https://github.com/nvim-neotest/neotest",
		data = {
			lazy = {
				keys = {
					{ "n", "<leader>tf", "Test run file" },
					{ "n", "<leader>tn", "Test run nearest" },
					{ "n", "<leader>tdn", "Test debug nearest" },
					{ "n", "<leader>tl", "Test run last" },
					{ "n", "<leader>tdl", "Test debug last" },
					{ "n", "<leader>tt", "Test summary toggle" },
				},
			},
		},
	},
	"https://github.com/nvim-neotest/neotest-python",
	"https://github.com/nvim-neotest/neotest-plenary",
	{
		src = "https://github.com/fredrikaverpil/neotest-golang",
		data = { build = "go install gotest.tools/gotestsum@latest" },
	},
	"https://github.com/rouge8/neotest-rust",
}, function()
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
end)
