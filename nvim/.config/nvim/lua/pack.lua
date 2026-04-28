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
