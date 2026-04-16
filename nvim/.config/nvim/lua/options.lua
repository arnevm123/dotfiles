vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.compatible = false
vim.opt.foldlevel = 999
vim.opt.inccommand = "split"

vim.opt.guicursor = ""
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorlineopt = "number"
vim.opt.cursorline = true
vim.opt.laststatus = 3

vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/databases/undodir"
vim.opt.cpoptions:append(">") -- when you yank multiple times into a register, this puts each on a new line

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.termguicolors = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "└"
vim.opt.updatetime = 50
vim.opt.scrolloff = 8
vim.opt.pumheight = 10
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80,120"
vim.opt.spelllang = "en_gb"
vim.opt.confirm = true

vim.o.diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram"
vim.o.winborder = "rounded"
vim.o.exrc = true

function Fd(file_pattern, _)
	-- if first char is * then fuzzy search
	if file_pattern:sub(1, 1) == "*" then file_pattern = file_pattern:gsub(".", ".*%0") .. ".*" end
	local cmd = 'fd --color=never --full-path --type file --hidden --exclude=".git" --exclude="deps" "'
		.. file_pattern
		.. '"'
	local result = vim.fn.systemlist(cmd)
	return result
end

vim.opt.listchars = {
	multispace = "·",
	leadmultispace = "· ",
	lead = "·",
	trail = "·",
	tab = "─ ",
	nbsp = "␣",
}
vim.opt.list = true

vim.opt.findfunc = "v:lua.Fd"

vim.opt.grepprg = "rg --vimgrep --smart-case"

vim.opt.path:append("**")
