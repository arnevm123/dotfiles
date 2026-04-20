local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
	callback = function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 125 }) end,
	desc = "Highlight on yank",
})

-- Remove 'o' from formatoptions (ftplugins keep adding it back)
autocmd("FileType", {
	pattern = "*",
	callback = function() vim.opt_local.formatoptions:remove({ "o" }) end,
	desc = "Remove 'o' from formatoptions",
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		if vim.bo.binary or vim.tbl_contains({ "diff" }, vim.bo.filetype) then return end
		local cursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[keepjumps keeppatterns %s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, cursor)
	end,
})

-- Prevent saving files with forbidden names
vim.cmd([[
autocmd BufWritePre /\v^[:;]12.{,3}$/ try | echoerr 'Forbidden file name: ' .. expand('<afile>') | endtry
]])

-- Restore cursor position when reopening a file
autocmd("BufWinEnter", {
	desc = "Restore cursor position",
	callback = function()
		local dominated = { "gitcommit", "gitrebase", "commit", "rebase" }
		if vim.tbl_contains(dominated, vim.bo.filetype) then return end
		if vim.bo.buftype ~= "" then return end
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
