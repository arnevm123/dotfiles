local icons = {
	readonly = "R",
	modified = "●",
	unsaved_others = "○",
}

-- Single diagnostic call, count by severity
local function diagnostic()
	local diags = vim.diagnostic.get(0)
	if #diags == 0 then return "" end

	local counts = { 0, 0, 0, 0 } -- ERROR, WARN, INFO, HINT
	for _, d in ipairs(diags) do
		counts[d.severity] = counts[d.severity] + 1
	end

	local parts = {}
	if counts[4] > 0 then table.insert(parts, "h: " .. counts[4]) end
	if counts[3] > 0 then table.insert(parts, "i: " .. counts[3]) end
	if counts[2] > 0 then table.insert(parts, "W: " .. counts[2]) end
	if counts[1] > 0 then table.insert(parts, "E: " .. counts[1]) end

	return " " .. table.concat(parts, " | ")
end

-- Track unsaved buffers via autocmd instead of scanning every redraw
local has_unsaved_others = false

local function refresh_unsaved()
	local cur = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= cur and vim.bo[buf].buflisted and vim.bo[buf].modified then
			has_unsaved_others = true
			return
		end
	end
	has_unsaved_others = false
end

vim.api.nvim_create_autocmd({ "BufModifiedSet", "BufEnter", "BufDelete" }, {
	group = vim.api.nvim_create_augroup("statusline_unsaved", { clear = true }),
	callback = refresh_unsaved,
})

local function unsaved_buffers()
	if has_unsaved_others then return " " .. icons.unsaved_others .. " " end
	return ""
end

local function file_section()
	local name = vim.fn.expand("%")
	local cwd = vim.fn.getcwd()
	if vim.startswith(name, cwd) then name = name:sub(#cwd + 1) end

	local attr = ""
	if vim.bo.modified and vim.bo.readonly then
		attr = icons.modified .. " " .. icons.readonly
	elseif vim.bo.readonly then
		attr = icons.readonly
	elseif vim.bo.modified then
		attr = icons.modified
	end
	if attr ~= "" then attr = " " .. attr end

	if name == "" then name = "No Name" end
	return name .. attr
end

-- Git info with async refresh and proper cache invalidation
local git_cache = {} -- keyed by cwd: { remote, branch }

local function git_fetch(root)
	local entry = git_cache[root] or {}
	git_cache[root] = entry

	-- Remote (rarely changes, fetch once)
	if not entry.remote then
		vim.system({ "git", "-C", root, "config", "--get", "remote.origin.url" }, {}, function(out)
			local remote = "No remote"
			if out.code == 0 and out.stdout and out.stdout ~= "" then
				remote = vim.fs.basename(vim.trim(out.stdout)) or "No remote"
				remote = vim.fn.fnamemodify(remote, ":r")
			end
			entry.remote = remote
			vim.schedule(function() vim.cmd.redrawstatus() end)
		end)
	end

	-- Branch (changes often, always refresh)
	vim.system({ "git", "-C", root, "branch", "--show-current" }, {}, function(out)
		if out.code == 0 and out.stdout then
			entry.branch = vim.trim(out.stdout)
		else
			entry.branch = nil
		end
		vim.schedule(function() vim.cmd.redrawstatus() end)
	end)
end

-- Invalidate branch cache on common git events
vim.api.nvim_create_autocmd({ "DirChanged", "FocusGained", "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("statusline_git", { clear = true }),
	callback = function()
		local root = vim.fn.getcwd()
		local entry = git_cache[root]
		if entry then entry.branch = nil end
		git_fetch(root)
	end,
})

-- Initial fetch on first statusline render
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("statusline_git_init", { clear = true }),
	once = true,
	callback = function() git_fetch(vim.fn.getcwd()) end,
})

local function get_git_info()
	local root = vim.fn.getcwd()
	local entry = git_cache[root]
	if not entry then
		git_fetch(root)
		return ""
	end

	local remote = entry.remote
	local branch = entry.branch or ""

	if remote == "No remote" or not remote then return "" end
	if #branch > 25 then branch = branch:sub(1, 22) .. "..." end

	return "[" .. remote .. "] (" .. branch .. ") "
end

local function grapple_tags(opts)
	local ok, grp = pcall(require, "grapple")
	if not ok then return "" end

	local tags, err = grp.tags(opts)
	if not tags then return err end

	local current = grp.find({ buffer = 0, scope = opts and opts.scope or nil })

	local output = {}
	for _, tag in ipairs(tags) do
		if tag.name then
			if current and current.path == tag.path then
				table.insert(output, "[" .. tag.name .. "]")
			else
				table.insert(output, " " .. tag.name .. " ")
			end
		end
	end
	return table.concat(output)
end

local function grapple_section()
	local branch = grapple_tags()
	local git = grapple_tags({ scope = "git" })
	if git == "" then return branch end
	if branch == "" then return git end
	return branch .. " | " .. git
end

local function left_section() return file_section() .. diagnostic() .. unsaved_buffers() end
local function right_section() return grapple_section() .. " " .. get_git_info() .. "%3l/%-3L" end

local M = {}

M.set_statusline = function() return left_section() .. "%=" .. right_section() end

vim.o.statusline = "%!v:lua.require('statusline').set_statusline()"

return M
