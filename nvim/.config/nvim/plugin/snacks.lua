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
map("n", "<leader>gb", function() Snacks.git.blame_line() end, "Git blame line")
map("n", "<leader>gB", function() Snacks.gitbrowse() end, "Git browse")
map("n", "]r", function() Snacks.words.jump(vim.v.count1) end, "Next reference")
map("n", "[r", function() Snacks.words.jump(-vim.v.count1) end, "Previous reference")
map("n", "yor", function()
	if Snacks.words.is_enabled() then
		Snacks.words.disable()
	else
		Snacks.words.enable()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":<Esc>", true, false, true), "n", false)
	end
end, "Toggle LSP word highlights")
map("n", "<leader>ff", function() Snacks.picker.resume() end, "Resume picker")
map("n", "<leader>fd", function() Snacks.picker.files() end, "Find files")
map("n", "<leader>fs", function() Snacks.picker.grep() end, "Live grep")
map("n", "<leader>fo", function()
	Snacks.picker.recent({
		filter = {
			cwd = true,
			filter = function(item) return vim.fn.isdirectory(item.file) == 0 end,
		},
	})
end, "Recent files")
map("n", "<leader>f/", function() Snacks.picker.lines() end, "Buffer lines")
map("n", "<leader>fh", function() Snacks.picker.help() end, "Help tags")
map("n", "<leader>fk", function() Snacks.picker.keymaps() end, "Keymaps")
map({ "n", "x" }, "<leader>fu", function() Snacks.picker.grep_word() end, "Grep word or selection")
map("n", "<leader>ft", function() Snacks.picker() end, "Pickers list")
map("n", "<leader>fj", function() Snacks.picker.jumps() end, "Jumps")
map("n", "<leader>bb", function() Snacks.picker.buffers() end, "Buffers")
map("n", "<leader>fis", function() Snacks.picker.grep({ cwd = vim.fn.expand("%:h") }) end, "Live grep in file dir")
map("n", "<leader>fid", function() Snacks.picker.files({ cwd = vim.fn.expand("%:h") }) end, "Find files in file dir")
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
map("n", "yoe", function() Snacks.toggle.diagnostics():toggle() end, "Toggle diagnostics")
