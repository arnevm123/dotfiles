vim.pack.add({ "https://github.com/kkharji/sqlite.lua" })
vim.pack.add({ "https://github.com/gbprod/yanky.nvim" })
vim.pack.add({ "https://github.com/ptdewey/yankbank-nvim" })

-- yanky
require("yanky").setup({
	system_clipboard = { sync_with_ring = false },
	highlight = { timer = 75, on_yank = false },
	preserve_cursor_position = { enabled = false },
	textobj = { enabled = true },
})

local map = require("keymaps").map
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", "Put after (yanky)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", "Put before (yanky)")
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", "GPut after (yanky)")
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", "GPut before (yanky)")
map("n", "<c-n>", "<Plug>(YankyNextEntry)", "Yanky next entry")
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)", "Yanky previous entry")

-- yankbank
require("yankbank").setup({
	persist_type = "sqlite",
	pickers = { snacks = true },
})

map("n", "<leader>f;", "<cmd>lua Snacks.picker.yankbank()<CR>", "Yank bank")
