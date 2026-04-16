vim.pack.add({ "https://github.com/monaqa/dial.nvim" })

local augend = require("dial.augend")
require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.constant.alias.bool,
		augend.semver.alias.semver,
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%m/%d/%Y"],
		augend.date.alias["%H:%M"],
		augend.constant.new({ elements = { ">=", "<" }, word = false, cyclic = true }),
		augend.constant.new({ elements = { ">", "<=" }, word = false, cyclic = true }),
		augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
		augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }),
		augend.constant.new({ elements = { "Info", "Warn", "Error" }, word = false, cyclic = true }),
		augend.constant.new({ elements = { "Truthy", "Falsy" }, word = false, cyclic = true }),
	},
})
vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true, silent = true })
