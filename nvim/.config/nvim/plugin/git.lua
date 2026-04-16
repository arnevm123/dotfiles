vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/TimUntersberger/neogit",
})
vim.pack.add({ "https://github.com/sindrets/diffview.nvim" })
vim.pack.add({ "https://github.com/tpope/vim-fugitive" })
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

-- Diffview
require("diffview").setup({
	use_icons = false,
	view = {
		default = { layout = "diff2_horizontal" },
		merge_tool = { layout = "diff3_mixed", disable_diagnostics = true },
		file_history = { layout = "diff2_horizontal" },
	},
})

-- Neogit
require("neogit").setup({
	ignored_settings = {},
	disable_signs = false,
	disable_hint = false,
	disable_context_highlighting = false,
	disable_commit_confirmation = false,
	auto_refresh = true,
	disable_builtin_notifications = false,
	use_magit_keybindings = false,
	kind = "tab",
	commit_popup = { kind = "split" },
	popup = { kind = "split" },
	signs = {
		section = { ">", "v" },
		item = { ">", "v" },
		hunk = { "", "" },
	},
	integrations = { diffview = true },
	sections = {
		untracked = { folded = false },
		unstaged = { folded = false },
		staged = { folded = false },
		stashes = { folded = true },
		unpulled = { folded = true, hidden = false },
		unmerged = { folded = false, hidden = false },
		recent = { folded = true },
	},
})

-- Gitsigns
require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "║" },
	},
	signcolumn = true,
	numhl = false,
	linehl = false,
	word_diff = false,
	watch_gitdir = { interval = 1000, follow_files = true },
	attach_to_untracked = true,
	current_line_blame = false,
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil,
	max_file_length = 40000,
	preview_config = {
		border = "none",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
})

-- Keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Neogit
keymap("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "open Neogit" })
keymap("n", "<leader>GG", "<cmd>DiffviewOpen master<CR>", { desc = "open diff with master" })

-- Gitsigns
keymap("n", "]g", "<cmd>Gitsigns next_hunk<CR>", { desc = "Gitsigns next hunk" })
keymap("n", "[g", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Gitsigns prev hunk" })
keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Gitsigns preview hunk" })
keymap({ "n", "v" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Gitsigns reset hunk" })
keymap({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Gitsigns stage hunk" })
keymap({ "n", "v" }, "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Gitsigns undo stage hunk" })
keymap("n", "<leader>gar", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Gitsigns reset buffer" })
keymap("n", "<leader>gau", "<cmd>Gitsigns undo_stage_buffer<CR>", { desc = "Gitsigns undo stage buffer" })
keymap("n", "<leader>gas", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Gitsigns stage buffer" })
keymap("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<CR>", { desc = "Gitsigns diff with HEAD" })
keymap("n", "<leader>gm", function()
	local branch = require("utils").git_main()
	if not branch then
		branch = vim.fn.input("No main branch found, enter branch name > ")
		if not branch or branch == "" then return end
	end
	require("gitsigns").diffthis(branch)
end, { desc = "Gitsigns diff with main" })
keymap("n", "<leader>gl", "<cmd>Gitsigns blame_line<CR>", { desc = "Gitsigns blame current line" })
keymap("n", "yob", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle inline blame" })
keymap(
	"n",
	"<leader>gal",
	function() require("gitsigns").blame_line({ full = true }) end,
	{ desc = "Gitsigns blame full" }
)
keymap("n", "<leader>gad", function() require("gitsigns").diffthis("~") end, opts)

-- Fugitive
keymap("n", "<leader>gh", "<cmd>0Gclog<CR>", { desc = "Git history" })
keymap("x", "<leader>gh", "<cmd>Gclog<CR>", { desc = "Git history" })
