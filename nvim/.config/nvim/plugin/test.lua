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

local map = require("keymaps").map
map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, "Test run file")
map("n", "<leader>tn", function() require("neotest").run.run() end, "Test run nearest")
map("n", "<leader>tdn", function() require("neotest").run.run({ strategy = "dap" }) end, "Test debug nearest")
map("n", "<leader>tl", function() require("neotest").run.run_last() end, "Test run last")
map("n", "<leader>tdl", function() require("neotest").run.run_last({ strategy = "dap" }) end, "Test debug last")
map("n", "<leader>tt", function() require("neotest").summary.toggle() end, "Test summary toggle")
