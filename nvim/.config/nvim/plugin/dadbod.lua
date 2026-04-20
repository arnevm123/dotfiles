vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
})

vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_dotenv_variable_prefix = "DB_UI_"
vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/" .. ".db_connections"
vim.g.db_ui_execute_on_save = 0

local map = require("keymaps").map

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dbout",
	callback = function()
		map("n", "gd", "<Plug>(DBUI_JumpToForeignKey)", "Jump to foreign key", { buffer = 0, noremap = false })
	end,
})

map("n", "<leader>qt", "<cmd>DBUIToggle<CR>", "DadBod toggle")
map("n", "<leader>qo", function() require("utils").DbuiToggle() end, "DadBod open new tab")
map({ "v", "x", "n" }, "<leader>qq", "<Plug>(DBUI_ExecuteQuery)", "DadBod run query")
map({ "v", "x", "n" }, "<C-q>", "<Plug>(DBUI_ExecuteQuery)", "DadBod run query")
