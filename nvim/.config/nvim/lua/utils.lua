local M = {}
function M.remove_bg()
	local highlights = {
		"Normal",
		"DiagnosticVirtualTextError",
		"DiagnosticVirtualTextHint",
		"DiagnosticVirtualTextInfo",
		"DiagnosticVirtualTextWarn",
		"CursorLineNr",
		"LineNr",
		"Folded",
		"NonText",
		"SpecialKey",
		"VertSplit",
		"SignColumn",
		"EndOfBuffer",
	}
	for _, highlight in pairs(highlights) do
		vim.cmd.highlight(highlight .. " guibg=none ctermbg=none")
	end

	local hl = {
		"Float",
		"NormalFloat",
		"FloatBorder",
		"Title",
	}
	for _, t in pairs(hl) do
		vim.cmd.highlight(t .. " guibg=#2B2B2B")
	end

	local groups = vim.fn.getcompletion("@lsp", "highlight")
	if groups then
		for _, group in ipairs(groups) do
			vim.api.nvim_set_hl(0, group, {})
		end
	end
end

function M.git_cwd()
	local cwd = vim.loop.cwd()
	local root = vim.fn.system("git rev-parse --show-toplevel")
	if vim.v.shell_error == 0 and root ~= nil then return string.gsub(root, "\n", "") end
	return cwd
end

function M.git_main()
	local root = vim.fn.system("git branch | cut -c 3- | grep -E '^master$|^main$'")
	if vim.v.shell_error ~= 0 or root == nil then return false end
	return root:gsub("^\n*", ""):gsub("\n*$", "")
end

function M.borders()
	local border = {
		{ "", "FloatBorder" },
		{ " ", "FloatBorder" },
		{ "", "FloatBorder" },
		{ "", "FloatBorder" },
		{ "", "FloatBorder" },
		{ "", "FloatBorder" },
		{ "", "FloatBorder" },
		{ "", "FloatBorder" },
	}
	return border
end

function M:Go_to_url(cmd)
	local sysname = vim.loop.os_uname().sysname
	local url = vim.fn.expand("<cfile>", nil, nil)
	if not url:match("http") then
		if url:match("github.com") or url:match("gopkg.in") or url:match("golang.org") then
			url = "https://" .. url
		else
			url = "https://github.com/" .. url
		end
	end

	vim.notify("Going to " .. url, "info", { title = "Opening browser..." })
	if sysname == "Darwin" then
		vim.fn.jobstart({ cmd or "open", url }, { on_exit = function() end })
	else
		vim.fn.jobstart({ cmd or "xdg-open", url }, { on_exit = function() end })
	end
end

-- make dd not remove last yank if empty
function M:Smart_dd()
	if vim.api.nvim_get_current_line():match("^%s*$") then
		return '"_dd'
	else
		return "dd"
	end
end

function M:CToggle()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then qf_exists = true end
	end
	if qf_exists == true then
		vim.cmd.cclose()
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then vim.cmd.copen() end
end

local virtual_text_enabled = true

function M:VirtualTextToggle()
	virtual_text_enabled = not virtual_text_enabled
	vim.diagnostic.config({ virtual_text = virtual_text_enabled })
end

local virtual_lines_enabled = false

function M:VirtualLinesToggle()
	virtual_lines_enabled = not virtual_lines_enabled
	vim.diagnostic.config({ virtual_lines = virtual_lines_enabled })
end

function M:DbuiToggle()
	local tabs = vim.api.nvim_list_tabpages()
	local dbui_enabled = false
	for _, tab in ipairs(tabs) do
		local wins = vim.api.nvim_tabpage_list_wins(tab)
		for _, win in ipairs(wins) do
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_name = vim.api.nvim_buf_get_name(buf)
			if buf_name:match("dbui") then dbui_enabled = true end
		end
	end
	if not dbui_enabled then
		vim.cmd.tabnew()
		vim.cmd.DBUI()
		return
	end
	vim.cmd.tabnext()
end

function M:FlogToggle()
	local tabs = vim.api.nvim_list_tabpages()

	for _, tab in ipairs(tabs) do
		local wins = vim.api.nvim_tabpage_list_wins(tab)
		for _, win in ipairs(wins) do
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_name = vim.api.nvim_buf_get_name(buf)
			if buf_name:match("flog") then
				local cur_tab = vim.api.nvim_get_current_tabpage()
				vim.api.nvim_set_current_tabpage(tab)
				vim.cmd.tabclose()
				if cur_tab ~= tab then vim.api.nvim_set_current_tabpage(cur_tab) end
				return
			end
		end
	end

	vim.cmd.Flog()
end

function M:isInTable(str, tbl)
	for _, value in ipairs(tbl) do
		if value == str then return true end
	end
	return false
end

function M:cspell_add()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics == 0 then
		vim.notify("No diagnostics", vim.log.levels.WARN)
		return
	end
	local words = {}

	for _, diagnostic in ipairs(diagnostics) do
		if diagnostic.source == "cspell" then
			local word = string.lower(diagnostic.message:match("%((.-)%)"))
			if not M:isInTable(word, words) then table.insert(words, word) end
		end
	end
	if #words == 0 then vim.notify("No error from cspell found", vim.log.levels.WARN) end
	local index = 1
	if #words > 1 then
		local input_list = { "Select word to add:" }
		for i, word in ipairs(words) do
			table.insert(input_list, string.format("%d. %s", i, word))
		end

		index = vim.fn.inputlist(input_list)

		if index <= 0 then
			vim.notify("No word selected", vim.log.levels.INFO)
			return
		end
	end

	local opts = {
		on_exit = function()
			vim.fn.jobstart("sort -u -o ~/.config/linters/allowed-words ~/.config/linters/allowed-words")
			vim.notify("Added " .. words[index] .. " to the allowed words", vim.log.levels.INFO)
		end,
	}
	local command = "echo " .. words[index] .. " >> ~/.config/linters/allowed-words"
	vim.fn.jobstart(command, opts)
end

function M:open_last_file()
	local files = vim.v.oldfiles
	local cwd = vim.loop.cwd() .. "/"
	for _, file in ipairs(files) do
		local file_stat = vim.loop.fs_stat(file)
		if
			file_stat
			and file_stat.type == "file"
			and file ~= vim.fn.expand("%:p")
			and not string.find(file, ".git/COMMIT_EDITMSG")
			and vim.fn.matchstrpos(file, cwd)[2] ~= -1
		then
			vim.cmd.edit(file)
			return
		end
	end
end

---@param search_string string | string[]
---@param search_folders? string | string[]
---@param case_insensitive? boolean
function M:grep_string(search_string, search_folders, case_insensitive)
	if search_string == nil or search_string == "" then return end
	vim.fn.setqflist({}, "r")
	local folders = search_folders or vim.fn.getcwd()
	local cmd
	if case_insensitive then
		cmd = 'rg -u --vimgrep "' .. search_string .. '" ' .. folders
	else
		cmd = 'rg -S -u --vimgrep "' .. search_string .. '" ' .. folders
	end
	local function stdout_to_qf(_, data, _)
		for _, val in ipairs(data) do
			local split_line = vim.split(val, ":")
			local filename = split_line[1]
			local lnum = split_line[2]
			local col = split_line[3]
			local text = table.concat(vim.list_slice(split_line, 4), ":")
			if filename and lnum and col and text then
				vim.fn.setqflist({
					{
						filename = filename,
						lnum = lnum,
						col = col,
						text = text,
					},
				}, "a")
			end
		end
	end
	local opts = {
		on_stdout = stdout_to_qf,
		on_exit = function() vim.cmd.copen() end,
	}
	vim.fn.jobstart(cmd, opts)
end

---@class rg_opts
---@field search_string? string | string[]
---@field search_folder? string | string[]
---@field case_insensitive? boolean
---@field ask_folder? boolean
local rg_opts = {}

rg_opts.__index = rg_opts

---@param opts rg_opts
function M:rg(opts)
	opts = opts or {}
	local search_string = opts.search_string
	local cwd = vim.fn.getcwd()
	local search_folder = opts.search_folder or cwd
	if vim.fn.mode() == "v" then
		vim.cmd([[noautocmd sil norm "hy]])
		search_string = vim.fn.getreg("h")
	end

	if not search_string then search_string = vim.fn.input("Grep For > ") end
	if opts.ask_folder then search_folder = M:check_folder(vim.fn.input("Search in folder > "), cwd) end

	M:grep_string(search_string, search_folder, opts.case_insensitive)
end

---@param folder string
---@return string | string[]
function M:check_folder(folder, cwd)
	local sep = "/"
	if vim.fn.isdirectory(folder) == 1 then return folder end
	if vim.fn.isdirectory(cwd .. sep .. folder) == 1 then return cwd .. sep .. folder end
	local search_folder = M:search_folder(folder, cwd)
	if search_folder then return search_folder end
	return M:check_folder(vim.fn.input("Folder not found: try again > "))
end

---@param folder string
---@param root string
---@return string | nil
function M:search_folder(folder, root)
	local search = string.sub(folder, 1, 1) == "?"
	if not search then return nil end
	local search_path = folder:gsub("%?", ""):gsub("^%s+", ""):gsub("/", ".*"):gsub(" ", ".*")
	local command = "fd -p -t d " .. search_path .. " " .. root
	local output = vim.fn.system(command)
	if not output then return nil end
	return output:gsub("\n", " "):gsub(" +", " ")
end

function M.fzf_fd()
	local command =
		"fd -t f | fzf-tmux -w100% -h100% --layout=reverse --border=top --preview-window=up:75%,border-top --preview 'cat {}'"

	local output = vim.fn.system(command)
	if not output or output == "" then return end
	for line in vim.split(output, "\n") do
		if line and line ~= "" then
			vim.cmd.edit(line)
			vim.cmd.mode() -- equivalent to "mod"
			return
		end
	end
end

function M.toggle_case_rename()
	local cword = vim.fn.expand("<cword>")
	local first_char = cword:sub(1, 1)
	local rest = cword:sub(2)

	if first_char == first_char:lower() then
		first_char = first_char:upper()
	else
		first_char = first_char:lower()
	end

	vim.lsp.buf.rename(first_char .. rest)
end

local function can_lsp_rename()
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	for _, client in ipairs(clients) do
		if client.server_capabilities.renameProvider then
			local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
			local resp = client:request_sync("textDocument/prepareRename", params, 1000, 0)
			if resp and resp.result then return true end
		end
	end
	return false
end

function M:lint_fix()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics == 0 then
		vim.notify("No diagnostics", vim.log.levels.WARN)
		return
	end

	local fixes = {}
	for _, diag in ipairs(diagnostics) do
		if diag.source == "golangci-lint" then
			if diag.code == "revive" then
				local suggested = diag.message:match("should be (%S+)")
				if suggested then
					table.insert(fixes, {
						label = suggested .. " (revive)",
						new_text = suggested,
						kind = "rename",
					})
				end
			elseif diag.code == "misspell" then
				local original, replacement = diag.message:match("`(%S+)` is a misspelling of `(%S+)`")
				if replacement then
					table.insert(fixes, {
						label = replacement .. " (misspell)",
						old_text = original,
						new_text = replacement,
						kind = "misspell",
						diag = diag,
					})
				end
			end
		end
	end

	if #fixes == 0 then
		vim.notify("No fixable golangci-lint diagnostic found", vim.log.levels.WARN)
		return
	end

	local fix = fixes[1]
	if #fixes > 1 then
		local input_list = { "Select fix:" }
		for i, f in ipairs(fixes) do
			table.insert(input_list, string.format("%d. %s", i, f.label))
		end
		local index = vim.fn.inputlist(input_list)
		if index <= 0 then
			vim.notify("No fix selected", vim.log.levels.INFO)
			return
		end
		fix = fixes[index]
	end

	if can_lsp_rename() then
		vim.lsp.buf.rename(fix.new_text)
	elseif fix.kind == "misspell" then
		local d = fix.diag
		local line = vim.api.nvim_buf_get_lines(0, d.lnum, d.lnum + 1, false)[1]
		local new_line = line:gsub(fix.old_text, fix.new_text, 1)
		vim.api.nvim_buf_set_lines(0, d.lnum, d.lnum + 1, false, { new_line })
	end
end

function M:ai_fix_lint()
	local is_visual = vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "\22"
	local diagnostics

	if is_visual then
		vim.cmd([[noautocmd sil norm "hy]])
		local start_line = vim.fn.line("'<") - 1
		local end_line = vim.fn.line("'>") - 1
		local diags = {}
		for lnum = start_line, end_line do
			for _, d in ipairs(vim.diagnostic.get(0, { lnum = lnum })) do
				table.insert(diags, d)
			end
		end
		diagnostics = diags
	else
		local lnum = vim.fn.line(".") - 1
		diagnostics = vim.diagnostic.get(0, { lnum = lnum })
	end

	if #diagnostics == 0 then
		vim.notify("No diagnostics", vim.log.levels.WARN)
		return
	end

	local function send_fix(diag)
		local src = diag.source or "unknown"
		local prompt = "Fix the following linting error:\n- [" .. src .. "] " .. diag.message

		if is_visual then
			vim.cmd("normal! gv")
		else
			local min_lnum = diag.lnum
			local max_lnum = diag.end_lnum or diag.lnum
			vim.api.nvim_win_set_cursor(0, { min_lnum + 1, 0 })
			vim.cmd("normal! V")
			if max_lnum > min_lnum then vim.api.nvim_win_set_cursor(0, { max_lnum + 1, 0 }) end
		end

		require("99").visual({ additional_prompt = prompt })
	end

	if #diagnostics == 1 then
		send_fix(diagnostics[1])
		return
	end

	vim.ui.select(diagnostics, {
		prompt = "Select diagnostic to fix:",
		format_item = function(d)
			local src = d.source or "unknown"
			return "[" .. src .. "] " .. d.message
		end,
	}, function(choice)
		if not choice then return end
		send_fix(choice)
	end)
end

function M.try_lsp_rename(case)
	if can_lsp_rename() then
		if case then
			require("textcase").lsp_rename(case)
			return
		end
		vim.cmd.TextCaseOpenTelescopeLSPChange()
		return
	end

	if case then
		require("textcase").current_word(case)
		return
	end
	vim.cmd.TextCaseOpenTelescopeQuickChange()
end

function M.get_highest_severity(count)
	count = count or vim.diagnostic.count()

	local severity_order = {
		vim.diagnostic.severity.ERROR,
		vim.diagnostic.severity.WARN,
		vim.diagnostic.severity.INFO,
		vim.diagnostic.severity.HINT,
	}

	for _, s in ipairs(severity_order) do
		if count[s] and count[s] > 0 then return s end
	end

	return nil
end

return M
