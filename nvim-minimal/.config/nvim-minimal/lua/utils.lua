local M = {}

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
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end
	if qf_exists == true then
		vim.cmd("cclose")
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd("copen")
	end
end

local virtual_text_enabled = true

function M:VirtualTextToggle()
	virtual_text_enabled = not virtual_text_enabled
	vim.diagnostic.config({ virtual_text = virtual_text_enabled })
end

function M:search_diagnostics()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics == 0 then
		vim.notify("No diagnostics", vim.log.levels.WARN)
		return
	end

	local programming_language = vim.api.nvim_buf_get_option(0, "filetype")
	local severity = string.lower(vim.diagnostic.severity[diagnostics[1].severity])
	local clean_message = diagnostics[1].message:gsub("[A-Za-z0-9:/\\._%-]+[.][A-Za-z0-9]+", "")
	clean_message = clean_message:gsub("[A-Za-z0-9:/\\._%-]+[/\\][A-Za-z0-9:/\\._%-]+[.][A-Za-z0-9]+", "")
	local command = "xdg-open "
		.. '"https://duckduckgo.com/?q='
		.. "While developing "
		.. programming_language
		.. "I got this "
		.. severity
		.. ": "
		.. clean_message
		.. "?"
		.. '"'
	vim.fn.jobstart(command)
end

function M:open_last_file()
	local files = vim.v.oldfiles
	for _, file in ipairs(files) do
		local file_stat = vim.loop.fs_stat(file)
		if file_stat and file_stat.type == "file" and file ~= vim.fn.expand("%:p") then
			local cwd = vim.loop.cwd() .. require("plenary.path").path.sep
			if vim.fn.matchstrpos(file, cwd)[2] ~= -1 then
				vim.cmd("e " .. file)
				return
			end
		end
	end
end

---@param search_string string | string[]
---@param search_folders? string | string[]
---@param case_insensitive? boolean
function M:grep_string(search_string, search_folders, case_insensitive)
	if search_string == nil or search_string == "" then
		return
	end
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
		on_exit = function()
			vim.cmd("copen")
		end,
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

	if not search_string then
		search_string = vim.fn.input("Grep For > ")
	end
	if opts.ask_folder then
		search_folder = M:check_folder(vim.fn.input("Search in folder > "), cwd)
	end

	M:grep_string(search_string, search_folder, opts.case_insensitive)
end

---@param folder string
---@return string | string[]
function M:check_folder(folder, cwd)
	local sep = require("plenary.path").path.sep
	if vim.fn.isdirectory(folder) == 1 then
		return folder
	end
	if vim.fn.isdirectory(cwd .. sep .. folder) == 1 then
		return cwd .. sep .. folder
	end
	local search_folder = M:search_folder(folder, cwd)
	if search_folder then
		return search_folder
	end
	return M:check_folder(vim.fn.input("Folder not found: try again > "))
end

---@param folder string
---@param root string
---@return string | nil
function M:search_folder(folder, root)
	local search = string.sub(folder, 1, 1) == "?"
	if not search then
		return nil
	end
	local search_path = folder:gsub("%?", ""):gsub("^%s+", ""):gsub("/", ".*"):gsub(" ", ".*")
	local command = "fd -p -t d " .. search_path .. " " .. root
	local handle = io.popen(command)
	if handle == nil then
		return nil
	end
	local folders = ""
	for line in handle:lines() do
		folders = folders .. " " .. line
	end
	handle:close()
	return folders
end

function M.fzf_fd()
	local command = "fd -t f | fzf-tmux -w100% -h100% --border=none --preview-window=down:50%,border-top --preview 'bat -n --color=always {}'"

	local handle = io.popen(command)
	if handle == nil then
		return
	end
	for line in handle:lines() do
		if line and line ~= "" then
			vim.cmd("e " .. line)
			vim.cmd("mod")
			return
		end
	end
end

return M
