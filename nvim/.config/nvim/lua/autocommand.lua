local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
	callback = function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 75 }) end,
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

-- Recording indicator: change statusline color during macro recording
local statusline_bg = 0

autocmd("RecordingEnter", {
	callback = function()
		local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
		statusline_bg = statusline_hl.bg
		vim.api.nvim_set_hl(0, "StatusLine", { bg = "#6327A6" })
	end,
})

autocmd("RecordingLeave", {
	callback = function() vim.api.nvim_set_hl(0, "StatusLine", { bg = statusline_bg }) end,
})
