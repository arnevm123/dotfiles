local M = {}

-- Centralized build hook for vim.pack
-- Reads data.build from plugin specs and runs it on install/update.
-- Supports string (shell command) and function (custom logic) values.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.kind ~= "install" and ev.data.kind ~= "update" then return end
		local build = ev.data.spec.data and ev.data.spec.data.build
		if not build then return end
		if type(build) == "function" then
			build(ev.data)
		elseif type(build) == "string" then
			vim.system({ "sh", "-c", build }, { cwd = ev.data.path })
		end
	end,
})

--- Extract plugin name from a spec entry (URL string or table with src).
---@param spec string|table
---@return string?
local function spec_name(spec)
	local url = type(spec) == "string" and spec or (type(spec) == "table" and spec.src)
	if url then return url:match("[^/]+$") end
end

---@param events string|string[]
---@param load_group fun()
---@param cleanups fun()[]
local function setup_event_trigger(events, load_group, cleanups)
	local ev = type(events) == "string" and { events } or events --[[@as string[] ]]
	local id = vim.api.nvim_create_autocmd(ev, {
		once = true,
		callback = function() load_group() end,
	})
	table.insert(cleanups, function() pcall(vim.api.nvim_del_autocmd, id) end)
end

---@param cmds string|string[]
---@param load_group fun()
---@param cleanups fun()[]
local function setup_cmd_trigger(cmds, load_group, cleanups)
	local list = type(cmds) == "string" and { cmds } or cmds --[[@as string[] ]]
	for _, cmd in ipairs(list) do
		vim.api.nvim_create_user_command(cmd, function(info)
			vim.api.nvim_del_user_command(cmd)
			load_group()
			local exec = (info.mods or "") .. " " .. cmd .. " " .. (info.args or "")
			if info.bang then exec = cmd .. "! " .. (info.args or "") end
			vim.cmd(vim.trim(exec))
		end, { nargs = "*", bang = true, desc = "Lazy: " .. cmd })
		table.insert(cleanups, function() pcall(vim.api.nvim_del_user_command, cmd) end)
	end
end

---@param patterns string|string[]
---@param load_group fun()
---@param cleanups fun()[]
local function setup_ft_trigger(patterns, load_group, cleanups)
	local pat = type(patterns) == "string" and { patterns } or patterns --[[@as string[] ]]
	local id = vim.api.nvim_create_autocmd("FileType", {
		pattern = pat,
		once = true,
		callback = function(ev)
			load_group()
			vim.api.nvim_exec_autocmds("FileType", { buffer = ev.buf })
		end,
	})
	table.insert(cleanups, function() pcall(vim.api.nvim_del_autocmd, id) end)
end

---@param keys (string|table)[]
---@param load_group fun()
---@param cleanups fun()[]
local function setup_keys_trigger(keys, load_group, cleanups)
	for _, key in ipairs(keys) do
		local mode, lhs
		if type(key) == "string" then
			mode = "n"
			lhs = key
		else
			mode = key[1] or "n"
			lhs = key[2] or key[1]
		end
		local desc = (type(key) == "table" and (key[3] or key.desc)) or ("Lazy: " .. lhs)
		-- Check if any of the modes is visual (for gv restore)
		local has_visual = false
		if type(mode) == "table" then
			for _, m in ipairs(mode) do
				if m == "v" or m == "x" then has_visual = true end
			end
		else
			has_visual = mode == "v" or mode == "x"
		end
		vim.keymap.set(mode, lhs, function()
			pcall(vim.keymap.del, mode, lhs)
			load_group()
			if has_visual and vim.fn.mode():match("[vV\22]") then
				vim.api.nvim_feedkeys("gv", "n", false)
			end
			local keys_encoded = vim.api.nvim_replace_termcodes(lhs, true, false, true)
			vim.api.nvim_feedkeys(keys_encoded, "m", false)
		end, { desc = desc })
		table.insert(cleanups, function() pcall(vim.keymap.del, mode, lhs) end)
	end
end

--- Lazy-load a group of plugins on first trigger.
--- Specs use `data.lazy` to declare triggers: event, cmd, ft, keys.
--- The config function runs after all specs are packadd'ed.
---@param specs table[] same format as vim.pack.add()
---@param config? fun() setup function to run after loading
function M.lazy(specs, config)
	vim.pack.add(specs, { load = false })

	local loaded = false
	local cleanups = {} ---@type fun()[]

	local function load_group()
		if loaded then return end
		loaded = true
		for _, fn in ipairs(cleanups) do
			fn()
		end
		for _, spec in ipairs(specs) do
			local name = spec_name(spec)
			if name then pcall(vim.cmd.packadd, name) end
		end
		if config then config() end
	end

	for _, spec in ipairs(specs) do
		if type(spec) == "table" and spec.data and spec.data.lazy then
			local lazy = spec.data.lazy
			if lazy.event then setup_event_trigger(lazy.event, load_group, cleanups) end
			if lazy.cmd then setup_cmd_trigger(lazy.cmd, load_group, cleanups) end
			if lazy.ft then setup_ft_trigger(lazy.ft, load_group, cleanups) end
			if lazy.keys then setup_keys_trigger(lazy.keys, load_group, cleanups) end
		end
	end
end

return M
