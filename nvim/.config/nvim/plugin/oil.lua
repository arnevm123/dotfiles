-- Oil file browser (deferred)
local borders = require("utils").borders()

vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
	columns = { "permissions", "size" },
	buf_options = { buflisted = false },
	delete_to_trash = true,
	win_options = {
		wrap = false,
		signcolumn = "no",
		cursorcolumn = false,
		foldcolumn = "0",
		spell = false,
		list = false,
		conceallevel = 3,
		concealcursor = "n",
	},
	default_file_explorer = false,
	restore_win_options = true,
	skip_confirm_for_simple_edits = true,
	keymaps = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<leader>v"] = "actions.select_vsplit",
		["<leader>h"] = "actions.select_split",
		["<leader>t"] = "actions.select_tab",
		["<leader>p"] = "actions.preview",
		["<leader>r"] = "actions.refresh",
		["q"] = "actions.close",
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
		["~"] = "actions.tcd",
		["g."] = "actions.toggle_hidden",
	},
	use_default_keymaps = false,
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, _) return name == ".." or name == ".git" end,
	},
	float = {
		padding = 2,
		max_width = 0,
		max_height = 0,
		border = borders,
		win_options = { winblend = 10 },
	},
	preview = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = 0.9,
		min_height = { 5, 0.1 },
		height = nil,
		border = borders,
		win_options = { winblend = 0 },
	},
	progress = {
		max_width = 0.9,
		min_width = { 40, 0.4 },
		width = nil,
		max_height = { 10, 0.9 },
		min_height = { 5, 0.1 },
		height = nil,
		border = borders,
		minimized_border = borders,
		win_options = { winblend = 0 },
	},
})

require("keymaps").map("n", "-", "<cmd>Oil<cr>", "Oil file browser")
