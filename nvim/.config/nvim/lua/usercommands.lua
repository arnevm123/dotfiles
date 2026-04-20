vim.api.nvim_create_user_command("MarkdownPreviewToggle", function()
	local buf = vim.api.nvim_get_current_buf()

	-- If preview is already running -> stop it
	if vim.b[buf].markdown_preview_job then
		vim.fn.jobstop(vim.b[buf].markdown_preview_job)
		return
	end

	local job = vim.fn.jobstart({
		"markdown-preview",
		vim.fn.expand("%:."),
	}, {
		on_exit = function(job_id, exit_code, _)
			vim.schedule(function()
				-- Make sure buffer still exists
				if vim.api.nvim_buf_is_valid(buf) then
					-- Only clear if it's *this* job
					if vim.b[buf].markdown_preview_job == job_id then vim.b[buf].markdown_preview_job = nil end
				end

				vim.notify(("Markdown preview stopped (exit code %d)"):format(exit_code), vim.log.levels.INFO)
			end)
		end,
	})

	if job <= 0 then
		vim.notify("Failed to start markdown preview", vim.log.levels.ERROR)
		return
	end

	vim.b[buf].markdown_preview_job = job
	vim.notify("Markdown preview started", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("Restart", function()
	local file = vim.fn.fnameescape(vim.fn.expand("%:p"))
	-- stylua: ignore
	local cmd = "edit " .. file
	vim.cmd("restart " .. cmd)
end, {})
