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
local map = require("keymaps").map

-- Neogit
map("n", "<leader>gg", "<cmd>Neogit<CR>", "Open Neogit")
map("n", "<leader>GG", "<cmd>DiffviewOpen master<CR>", "Diffview against master")

-- Gitsigns
map("n", "]g", "<cmd>Gitsigns next_hunk<CR>", "Next git hunk")
map("n", "[g", "<cmd>Gitsigns prev_hunk<CR>", "Previous git hunk")
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", "Preview hunk inline")
map({ "n", "v" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", "Reset hunk")
map({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", "Stage hunk")
map({ "n", "v" }, "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo stage hunk")
map("n", "<leader>gar", "<cmd>Gitsigns reset_buffer<CR>", "Reset buffer")
map("n", "<leader>gau", "<cmd>Gitsigns undo_stage_buffer<CR>", "Undo stage buffer")
map("n", "<leader>gas", "<cmd>Gitsigns stage_buffer<CR>", "Stage buffer")
map("n", "<leader>gd", "<cmd>Gitsigns diffthis HEAD<CR>", "Diff with HEAD")
map("n", "<leader>gm", function()
	local branch = require("utils").git_main()
	if not branch then
		branch = vim.fn.input("No main branch found, enter branch name > ")
		if not branch or branch == "" then return end
	end
	require("gitsigns").diffthis(branch)
end, "Diff with main branch")
map("n", "<leader>gl", "<cmd>Gitsigns blame_line<CR>", "Blame current line")
map("n", "yob", "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle inline blame")
map("n", "<leader>gal", function() require("gitsigns").blame_line({ full = true }) end, "Blame line (full)")
map("n", "<leader>gad", function() require("gitsigns").diffthis("~") end, "Diff with previous commit")

-- Fugitive
map("n", "<leader>gh", "<cmd>0Gclog<CR>", "Git file history")
map("x", "<leader>gh", "<cmd>Gclog<CR>", "Git selection history")
