vim.pack.add({
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/Bilal2453/luvit-meta",
})
vim.pack.add({ "https://github.com/olexsmir/gopher.nvim" })

-- lazydev
require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		{ path = "snacks.nvim", words = { "Snacks" } },
	},
})

-- gopher
require("gopher").setup({
	gotests = { template = "testify" },
	iferr = { message = 'fmt.Errorf("%w", err)' },
})

local keymap = vim.keymap.set
keymap("n", "<leader>ee", '0f=llvt("hy:GoIfErr<CR>jf%i<C-r>h: <esc>', { desc = "Go if err" })
keymap("n", "<leader>er", function()
	local line = vim.api.nvim_get_current_line()
	if line:match("^%s*if") then
		if string.find(line, ";") then
			vim.api.nvim_feedkeys("^df f;s\x0dif \x1b", "n", true)
			return
		end
		vim.api.nvim_feedkeys("k", "n", true)
	end
	vim.api.nvim_feedkeys("Jcff;\x1bIif \x1b", "n", true)
end, { desc = "Go if err join" })
keymap("n", "<leader>ew", "^df f;s<CR>if <esc>", { desc = "Go if err split" })
keymap("n", "<leader>en", function()
	local var = vim.fn.expand("<cword>")
	vim.api.nvim_input("o" .. "_ = " .. var .. "<esc>^")
end, { desc = "Go empty assign" })
