vim.pack.add({
	"https://github.com/saghen/blink.compat",
	"https://github.com/ThePrimeagen/99",
})

-- 99.nvim
local _99 = require("99")
local cwd = vim.uv.cwd()
local basename = vim.fs.basename(cwd)
_99.setup({
	provider = _99.Providers.OpenCodeProvider,
	model = "opencode/big-pickle",
	logger = {
		level = _99.DEBUG,
		path = "/tmp/" .. basename .. ".99.debug",
		print_on_error = true,
	},
	tmp_dir = "./tmp",
	completion = {
		custom_rules = { "scratch/custom_rules/" },
		files = {},
		source = "blink",
	},
	md_files = { "AGENT.md" },
})

local map = require("keymaps").map
map("v", "<leader>av", function() require("99").visual({}) end, "AI visual")
map("n", "<leader>ax", function() require("99").stop_all_requests() end, "AI stop all requests")
map("n", "<leader>as", function() require("99").search({}) end, "AI search")
map("n", "<leader>ao", function() require("99").open() end, "AI open")
map("n", "<leader>ai", function() require("99").open() end, "AI open (alt)")
map({ "n", "v" }, "<leader>af", function() require("utils"):ai_fix_lint() end, "AI fix lint error")
