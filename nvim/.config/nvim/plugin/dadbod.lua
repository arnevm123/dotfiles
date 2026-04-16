vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
})

vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_dotenv_variable_prefix = "DB_UI_"
vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/" .. ".db_connections"
vim.g.db_ui_execute_on_save = 0

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dbout",
	callback = function()
		vim.api.nvim_buf_set_keymap(
			0,
			"n",
			"gd",
			"<Plug>(DBUI_JumpToForeignKey)",
			{ noremap = false, silent = true }
		)
	end,
})

local keymap = vim.keymap.set
keymap("n", "<leader>qt", "<cmd>DBUIToggle<CR>", { desc = "DadBod Toggle" })
keymap("n", "<leader>qo", "<cmd>lua require('utils').DbuiToggle()<CR>", { desc = "DadBod Open new tab" })
keymap({ "v", "x", "n" }, "<leader>qq", "<PLUG>(DBUI_ExecuteQuery)", { desc = "DadBod run query" })
keymap({ "v", "x", "n" }, "<C-q>", "<PLUG>(DBUI_ExecuteQuery)", { desc = "DadBod run query" })
