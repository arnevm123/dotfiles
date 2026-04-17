local utils = require("utils")

local M = {}

---Set a keymap with default opts (noremap=true, silent=true) and a required description.
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string
---@param extra? table
function M.map(mode, lhs, rhs, desc, extra)
	local o = vim.tbl_extend("force", { noremap = true, silent = true, desc = desc }, extra or {})
	vim.keymap.set(mode, lhs, rhs, o)
end

local map = M.map

-- Leader key
map("", "<Space>", "<Nop>", "Disable space")
map("n", "k", "v:count == 0 ? 'gk' : 'k'", "Move up (display lines)", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", "Move down (display lines)", { expr = true })

-- LSP
map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", "Show diagnostic float")
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition")
map("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Go to type definition")
map("n", "gr", "<cmd>lua vim.lsp.buf.references({includeDeclaration = false})<CR>", "Find references", { nowait = true })
map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation")
map("n", "<leader>K", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature help")
map("i", "<c-;>", "<cmd>lua vim.lsp.inline_completion.get()<CR>", "Inline completion")
map("n", "[w", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, "Previous error")
map("n", "]w", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, "Next error")

-- Jump to end of tree-sitter node in insert mode
map("i", "<C-l>", function()
	local node = vim.treesitter.get_node()
	if node ~= nil then
		local row, col = node:end_()
		pcall(vim.api.nvim_win_set_cursor, 0, { row + 1, col })
	else
		vim.notify("no node found", vim.log.levels.WARN)
	end
end, "Jump to end of TS node")

-- Correct spelling in insert mode
map("i", "<C-s>", "<c-g>u<Esc>[s1z=gi<c-g>u", "Fix nearest spelling error")

-- Resize with Ctrl-arrows
map("n", "<C-down>", "<cmd>resize +2<CR>", "Increase window height")
map("n", "<C-up>", "<cmd>resize -2<CR>", "Decrease window height")
map("n", "<C-left>", "<cmd>vertical resize -2<CR>", "Decrease window width")
map("n", "<C-right>", "<cmd>vertical resize +2<CR>", "Increase window width")

map("n", "ycc", "yygccp", "Duplicate line commented", { remap = true })

-- Tabs
map("n", "<leader>TC", "<cmd>tabclose<CR>", "Close tab")
map("n", "<leader>TN", "<cmd>tabnew<CR>", "New tab")
map("n", "<leader>TO", "<cmd>tabonly<CR>", "Close other tabs")
map("n", "]T", "<cmd>tabnext<CR>", "Next tab")
map("n", "[T", "<cmd>tabprev<CR>", "Previous tab")

map("n", "<C-w>S", "<C-w>s<C-w>T", "Split and move to new tab")
map("c", "<tab>", "<C-z>", "Wildmenu completion", { silent = false })

-- Move text up and down
map("v", "<C-j>", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "<C-k>", ":m '<-2<CR>gv=gv", "Move selection up")

-- Visual mode helpers
map("v", ".", ":normal .<CR>", "Repeat last change", { silent = false })
map("x", "@", ":normal @q<CR>", "Run macro @q on selection", { silent = false })
map("x", "*", '"ry/\\V<C-r>r<CR>', "Search forward for selection", { silent = false })
map("x", "#", '"ry?\\V<C-r>r<CR>', "Search backward for selection", { silent = false })

map("n", "dd", utils.Smart_dd, "Smart dd (blank line to black hole)", { expr = true })
map("n", "gx", utils.Go_to_url, "Open URL under cursor")
map("n", "<leader>zg", function()
	---@diagnostic disable-next-line: param-type-mismatch
	utils.cspell_add(vim.fn.expand("<cword>"))
end, "Add word to cspell dictionary", { silent = false })

-- Ripgrep / fd
map("n", "<leader>rg", utils.rg, "Ripgrep search", { silent = false })
map("v", "<leader>rg", utils.rg, "Ripgrep search (visual)", { silent = false })
map("n", "<leader>rd", utils.fzf_fd, "Find files with fd", { silent = false })
map("n", "<leader>rf", function() utils:rg({ ask_folder = true }) end, "Ripgrep in folder", { silent = false })
map("n", "<leader>fq", function() utils:rg({ search_string = vim.fn.expand("<cword>") }) end, "Ripgrep word under cursor", { silent = false })
map("n", "<leader>RG", function() utils:rg({ case_insensitive = true }) end, "Ripgrep (case insensitive)", { silent = false })
map("v", "<leader>RG", function() utils:rg({ case_insensitive = true }) end, "Ripgrep (case insensitive, visual)", { silent = false })
map("n", "<leader>RF", function() utils:rg({ ask_folder = true, case_insensitive = true }) end, "Ripgrep in folder (case insensitive)", { silent = false })
map("n", "<leader>RU", function() utils:rg({ search_string = vim.fn.expand("<cword>"), case_insensitive = true }) end, "Ripgrep word (case insensitive)", { silent = false })
map("n", "<leader>ro", utils.open_last_file, "Open last file", { silent = false })
map("n", "<leader>rr", utils.restart_with_current_file, "Restart with current file", { silent = false })

-- Stay in indent mode
map("v", "<", "<gv", "Indent left and reselect")
map("v", ">", ">gv", "Indent right and reselect")

-- Diff
map("n", "[c", "<cmd>diffget //2<CR>", "Diffget from left (ours)")
map("n", "]c", "<cmd>diffget //3<CR>", "Diffget from right (theirs)")

-- Clipboard / register helpers
map("n", "<Leader>xp", "<cmd>call setreg('+', getreg('@'))<CR>", "Copy unnamed register to clipboard")
map("n", "<Leader>xc", "<cmd>call setreg('+', expand('%:.') .. ':' .. line('.'))<CR>", "Copy file:line to clipboard")
map("n", "<Leader>xo", ":e <C-r>+<CR>", "Open location from clipboard", { silent = false })

-- System clipboard yank/paste
map("n", "<leader>y", '"+y', "Yank to clipboard")
map("v", "<leader>y", '"+y', "Yank to clipboard")
map("n", "<leader>p", '"+p', "Paste from clipboard")
map("v", "<leader>p", '"+p', "Paste from clipboard")
map("n", "<leader>P", '"+P', "Paste from clipboard (before)")
map("v", "<leader>P", '"+P', "Paste from clipboard (before)")

-- Search and replace
map("x", "<leader>rk", ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>", "Regex replace on selection", { silent = false })
map("n", "<leader>rk", ":s/\\(.*\\)/\\1<left><left><left><left><left><left><left><left><left>", "Regex replace on line", { silent = false })
map("v", "<leader>re", '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>', "Replace selected text", { silent = false })
map("n", "<leader>re", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<Left><Left><Left><Left>", "Replace word under cursor", { silent = false })
map("v", "<leader>r#", '"hy:%s#<C-r>h#<C-r>h#gc<left><left><left>', "Replace selected (# delim)", { silent = false })
map("n", "<leader>r#", ":%s#\\<<C-r><C-w>\\>#<C-r><C-w>#gcI<Left><Left><Left><Left>", "Replace word (# delim)", { silent = false })

-- Tmux
map("n", "<leader>tm", "<cmd>let $VIM_DIR=expand('%:p:h')<CR>:silent !tmux split-window -hc $VIM_DIR<CR>", "Tmux split in file dir", { silent = false })
map("n", "<leader>tp", "<cmd>let $VIM_DIR=expand('%:p:h')<CR>:silent !tmux-popup.sh $VIM_DIR<CR>", "Tmux popup in file dir", { silent = false })

-- Go OS switching
map("n", "<leader>GU", "<cmd>call setenv('GOOS', '')<CR>:LspRestart<CR>", "Unset GOOS", { silent = false })
map("n", "<leader>GW", "<cmd>call setenv('GOOS', 'windows')<CR>:LspRestart<CR>", "Set GOOS=windows", { silent = false })
map("n", "<leader>GL", "<cmd>call setenv('GOOS', 'linux')<CR>:LspRestart<CR>", "Set GOOS=linux", { silent = false })

map("n", "yom", "<cmd>MarkdownPreviewToggle<CR>", "Toggle markdown preview")

map("n", "<leader>GE", function()
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
end, "Toggle e2e build tag for gopls")

-- Emacs-style insert/command mode movement (tpope/rsi)
map("i", "<C-B>", "<Left>", "Move left")
map("i", "<C-F>", "<Right>", "Move right")
map("c", "<C-B>", "<Left>", "Move left")
map("c", "<C-F>", "<Right>", "Move right")
map("i", "<C-A>", "<C-O>^", "Jump to first non-blank")
map("i", "<C-D>", "<Del>", "Delete character forward")
map("i", "<C-E>", "<End>", "Jump to end of line")

-- Toggles
map("n", "yoq", utils.CToggle, "Toggle quickfix")
map("n", "yov", utils.VirtualTextToggle, "Toggle virtual text diagnostics")
map("n", "yol", utils.VirtualLinesToggle, "Toggle virtual lines diagnostics")
map("n", "yoh", function() vim.o.hlsearch = not vim.o.hlsearch end, "Toggle search highlight")
map("n", "yos", function() vim.o.spell = not vim.o.spell end, "Toggle spell check")
map("n", "yow", function() vim.o.wrap = not vim.o.wrap end, "Toggle line wrap")

return M
