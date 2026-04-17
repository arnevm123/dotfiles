vim.pack.add({ "https://github.com/cbochs/grapple.nvim" })

local function get_scope(char)
	if char:match("%u") or char == '"' then return "git" end
	return "git_branch"
end

local function is_valid_mark(char)
	return char ~= "" and not vim.startswith(char, "<") and not vim.startswith(char, "\27")
end

local function is_menu_char(char) return char == "'" or char == '"' end

local function save_mark()
	local char = vim.fn.getcharstr()
	if not is_valid_mark(char) then return end
	if is_menu_char(char) then return end

	local grapple = require("grapple")
	local filepath = vim.api.nvim_buf_get_name(0)
	local filename = vim.fn.fnamemodify(filepath, ":t")
	local opts = { name = char, scope = get_scope(char) }

	local entry = grapple.find(opts)
	if entry then
		if entry.path == filepath then
			vim.notify(filename .. " is already marked as " .. char)
			return
		end
		local choice = vim.fn.confirm("Tag " .. char .. " already exists. Delete it?", "&Yes\n&No", 2)
		if choice ~= 1 then return end
	end
	grapple.tag(opts)
	vim.defer_fn(function() vim.notify("Marked " .. filename .. " as " .. char) end, 10)
end

local function open_mark()
	local char = vim.fn.getcharstr()
	if not is_valid_mark(char) then return end
	local grapple = require("grapple")
	if is_menu_char(char) then
		grapple.toggle_tags({ scope = get_scope(char) })
		return
	end
	grapple.select({ name = char, scope = get_scope(char) })
end

require("grapple").setup({
	name_pos = "start",
	icons = false,
	quick_select = "",
	scope = "git_branch",
	command = function(path)
		local bufnr = vim.fn.bufnr(path)
		if bufnr == -1 then bufnr = vim.fn.bufadd(path) end
		if not vim.api.nvim_buf_is_loaded(bufnr) then
			vim.fn.bufload(bufnr)
			vim.api.nvim_set_option_value("buflisted", true, { buf = bufnr })
		end
		vim.api.nvim_set_current_buf(bufnr)
	end,
	win_opts = {
		width = 90,
		height = 16,
		row = 0.5,
		col = 0.5,
		footer = "",
	},
})

local map = require("keymaps").map
map("n", "m", save_mark, "Save grapple mark")
map("n", "'", open_mark, "Open grapple mark")
