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

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")

-- yankbank
require("yankbank").setup({
	persist_type = "sqlite",
	pickers = { snacks = true },
})

vim.keymap.set("n", "<leader>f;", "<cmd>lua Snacks.picker.yankbank()<CR>", { desc = "Yank bank" })
