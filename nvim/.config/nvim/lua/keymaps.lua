local utils = require("utils")
local nosilent = { noremap = true }
local opts = { noremap = true, silent = true }
local expr = { noremap = true, expr = true }

local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--LSP
keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
keymap(
	"n",
	"gr",
	"<cmd>lua vim.lsp.buf.references({includeDeclaration = false})<CR>",
	{ noremap = true, silent = true, nowait = true }
)
keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "<leader>K", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("i", "<c-;>", "<cmd>lua vim.lsp.inline_completion.get()<CR>", opts)
keymap("n", "[w", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, opts)
keymap("n", "]w", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, opts)

-- Jump to the end of the tree-sitter node in insert mode
keymap("i", "<C-l>", function()
	local node = vim.treesitter.get_node()
	if node ~= nil then
		local row, col = node:end_()
		pcall(vim.api.nvim_win_set_cursor, 0, { row + 1, col })
	else
		vim.notify("no node found", vim.log.levels.WARN)
	end
end, { desc = "insjump" })
-- Correct spelling in insert mode
keymap("i", "<C-s>", "<c-g>u<Esc>[s1z=gi<c-g>u")

-- Resize with Shift-arrows
keymap("n", "<C-down>", "<cmd>resize +2<CR>", opts)
keymap("n", "<C-up>", "<cmd>resize -2<CR>", opts)
keymap("n", "<C-left>", "<cmd>vertical resize -2<CR>", opts)
keymap("n", "<C-right>", "<cmd>vertical resize +2<CR>", opts)

keymap("n", "ycc", "yygccp", { remap = true })

keymap("n", "<leader>TC", "<cmd>tabclose<CR>", opts)
keymap("n", "<leader>TN", "<cmd>tabnew<CR>", opts)
keymap("n", "<leader>TO", "<cmd>tabonly<CR>", opts)
keymap("n", "]T", "<cmd>tabnext<CR>", opts)
keymap("n", "[T", "<cmd>tabprev<CR>", opts)

keymap("n", "<C-w>S", "<C-w>s<C-w>T", opts)
keymap("c", "<tab>", "<C-z>", nosilent)

-- Move text up and down
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- Add some help to visual mode
keymap("v", ".", ":normal .<CR>", nosilent)
keymap("x", "@", ":normal @q<CR>", nosilent)
keymap("x", "*", '"ry/\\V<C-r>r<CR>', nosilent)
keymap("x", "#", '"ry?\\V<C-r>r<CR>', nosilent)

keymap("n", "dd", utils.Smart_dd, expr)
keymap("n", "gx", utils.Go_to_url, opts)
keymap("n", "<leader>zg", function()
	---@diagnostic disable-next-line: param-type-mismatch
	utils.cspell_add(vim.fn.expand("<cword>"))
end, nosilent)

keymap("n", "<leader>rg", utils.rg, nosilent)
keymap("v", "<leader>rg", utils.rg, nosilent)
keymap("n", "<leader>rd", utils.fzf_fd, nosilent)

keymap("n", "<leader>rf", function() utils:rg({ ask_folder = true }) end, nosilent)

keymap("n", "<leader>fq", function() utils:rg({ search_string = vim.fn.expand("<cword>") }) end, nosilent)

keymap("n", "<leader>RG", function() utils:rg({ case_insensitive = true }) end, nosilent)

keymap("v", "<leader>RG", function() utils:rg({ case_insensitive = true }) end, nosilent)

keymap("n", "<leader>RF", function() utils:rg({ ask_folder = true, case_insensitive = true }) end, nosilent)

keymap(
	"n",
	"<leader>RU",
	function() utils:rg({ search_string = vim.fn.expand("<cword>"), case_insensitive = true }) end,
	nosilent
)

keymap("n", "<leader>ro", utils.open_last_file, nosilent)
keymap("n", "<leader>rr", utils.restart_with_current_file, nosilent)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("n", "[c", "<cmd>diffget //2<CR>", opts)
keymap("n", "]c", "<cmd>diffget //3<CR>", opts)
keymap("n", "<Leader>xp", "<cmd>call setreg('+', getreg('@'))<CR>", opts)
keymap("n", "<Leader>xc", "<cmd>call setreg('+', expand('%:.') .. ':' .. line('.'))<CR>", opts)
keymap("n", "<Leader>xo", ":e <C-r>+<CR>", { noremap = true, desc = "Go to location in clipboard" })

-- next greatest remap ever : asbjornHaland
keymap("n", "<leader>y", '"+y', opts)
keymap("v", "<leader>y", '"+y', opts)

keymap("n", "<leader>p", '"+p', opts)
keymap("v", "<leader>p", '"+p', opts)
keymap("n", "<leader>P", '"+P', opts)
keymap("v", "<leader>P", '"+P', opts)

-- search and replace stuff
keymap("x", "<leader>rk", ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>", nosilent)
keymap("n", "<leader>rk", ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>", nosilent)
keymap("v", "<leader>re", '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>', nosilent)
keymap("n", "<leader>re", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>", nosilent)
keymap("v", "<leader>r#", '"hy:%s#<C-r>h#<C-r>h#gc<left><left><left>', nosilent)
keymap("n", "<leader>r#", ":%s#\\<<C-r><C-w>\\>#<C-r><C-w>#gcI<Left><Left><Left><Left>", nosilent)

keymap("n", "<leader>tm", "<cmd>let $VIM_DIR=expand('%:p:h')<CR>:silent !tmux split-window -hc $VIM_DIR<CR>", nosilent)
keymap("n", "<leader>tp", "<cmd>let $VIM_DIR=expand('%:p:h')<CR>:silent !tmux-popup.sh $VIM_DIR<CR>", nosilent)

keymap("n", "<leader>GU", "<cmd>call setenv('GOOS', '')<CR>:LspRestart<CR>", nosilent)
keymap("n", "<leader>GW", "<cmd>call setenv('GOOS', 'windows')<CR>:LspRestart<CR>", nosilent)
keymap("n", "<leader>GL", "<cmd>call setenv('GOOS', 'linux')<CR>:LspRestart<CR>", nosilent)
keymap("n", "yom", "<cmd>MarkdownPreviewToggle<CR>", opts)
keymap("n", "<leader>GE", function()
	local clients = vim.lsp.get_clients({ name = "gopls" })
	for _, client in ipairs(clients) do
		local settings = client.config.settings or {}
		settings.gopls = settings.gopls or {}
		local flags = settings.gopls.buildFlags or {}
		if vim.tbl_contains(flags, "-tags=e2e") then
			settings.gopls.buildFlags = {}
		else
			settings.gopls.buildFlags = { "-tags=e2e" }
		end
		client.config.settings = settings
		client.notify("workspace/didChangeConfiguration", { settings = settings })
	end
end, { desc = "Toggle e2e build tag for gopls" })

-- TPOPE RSI
keymap("i", "<C-B>", "<Left>", opts)
keymap("i", "<C-F>", "<Right>", opts)
keymap("c", "<C-B>", "<Left>", opts)
keymap("c", "<C-F>", "<Right>", opts)

keymap("i", "<C-A>", "<C-O>^", opts)
keymap("i", "<C-D>", "<Del>", opts)
keymap("i", "<C-E>", "<End>", opts)

keymap("n", "yoq", utils.CToggle, opts)
keymap("n", "yov", utils.VirtualTextToggle, opts)
keymap("n", "yol", utils.VirtualLinesToggle, opts)

keymap("n", "yoh", function() vim.o.hlsearch = not vim.o.hlsearch end, opts)
keymap("n", "yos", function() vim.o.spell = not vim.o.spell end, opts)
keymap("n", "yow", function() vim.o.wrap = not vim.o.wrap end, opts)
