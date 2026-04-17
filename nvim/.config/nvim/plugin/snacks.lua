-- Snacks: loaded eagerly (picker, bigfile, quickfile, git)
vim.pack.add({ "https://github.com/folke/snacks.nvim" })

---@type snacks.Config
local opts = {
	zen = { enabled = false },
	words = { enabled = false },
	scroll = { enabled = false },
	indent = { enabled = false },
	animate = { enabled = false },
	notifier = { enabled = false },
	statuscolumn = { enabled = false },
	picker = {
		enabled = true,
		sources = {
			select = {
				layout = {
					preset = "ivy_split",
					hidden = { "preview" },
				},
			},
		},
		layouts = { ivy_split = { layout = { height = 0.25 } } },
		layout = { preset = "ivy_split" },
	},
	bigfile = {
		enabled = true,
		size = 5 * 1024 * 1024,
		line_length = 100000,
	},
	quickfile = { enabled = true },
}

require("snacks").setup(opts)

-- Keymaps
local map = require("keymaps").map
map("n", "<leader>gb", "<cmd>lua Snacks.git.blame_line()<CR>", "Git blame line")
map("n", "<leader>gB", "<cmd>lua Snacks.gitbrowse()<CR>", "Git browse")
map("n", "]r", "<cmd>lua Snacks.words.jump(vim.v.count1)<CR>", "Next reference")
map("n", "[r", "<cmd>lua Snacks.words.jump(-vim.v.count1)<CR>", "Previous reference")
map("n", "yor", function()
	if Snacks.words.is_enabled() then
		Snacks.words.disable()
	else
		Snacks.words.enable()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":<Esc>", true, false, true), "n", false)
	end
end, "Toggle LSP word highlights")
map("n", "<leader>ff", "<cmd>lua Snacks.picker.resume()<CR>", "Resume picker")
map("n", "<leader>fd", "<cmd>lua Snacks.picker.files()<CR>", "Find files")
map("n", "<leader>fs", "<cmd>lua Snacks.picker.grep()<CR>", "Live grep")
map("n", "<leader>fo", function()
	Snacks.picker.recent({
		filter = {
			cwd = true,
			filter = function(item) return vim.fn.isdirectory(item.file) == 0 end,
		},
	})
end, "Recent files")
map("n", "<leader>f/", "<cmd>lua Snacks.picker.lines()<CR>", "Buffer lines")
map("n", "<leader>fh", "<cmd>lua Snacks.picker.help()<CR>", "Help tags")
map("n", "<leader>fk", "<cmd>lua Snacks.picker.keymaps()<CR>", "Keymaps")
map({ "n", "x" }, "<leader>fu", "<cmd>lua Snacks.picker.grep_word()<CR>", "Grep word or selection")
map("n", "<leader>ft", "<cmd>lua Snacks.picker()<CR>", "Pickers list")
map("n", "<leader>fj", "<cmd>lua Snacks.picker.jumps()<CR>", "Jumps")
map("n", "<leader>bb", "<cmd>lua Snacks.picker.buffers()<CR>", "Buffers")
map("n", "<leader>fis", '<cmd>lua Snacks.picker.grep({ cwd = vim.fn.expand("%:h") })<CR>', "Live grep in file dir")
map("n", "<leader>fid", '<cmd>lua Snacks.picker.files({ cwd = vim.fn.expand("%:h") })<CR>', "Find files in file dir")
map("n", "<leader>fp", function()
	local text = vim.fn.getreg("+")
	if not text or text == "" then
		vim.notify("No text in register", vim.log.levels.ERROR)
		return
	end
	text = text:match("([^\n]+)")
	text = text and vim.trim(text) or ""
	Snacks.picker.files({ default_text = text, hidden = true })
end, "Find copied file")

-- Diagnostics toggle
Snacks.toggle.diagnostics():map("yoe")
