 vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 75,
		})
	end,
})

local ignore_buftype = { "quickfix", "nofile", "help" }
local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
	callback = function()
		if vim.fn.line(".") > 1 then
			return
		end
		if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
			return
		end
		if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local buff_last_line = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= buff_last_line then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})

-- remove eol spaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function()
		local cursor_position = vim.fn.getpos(".")
		vim.cmd([[%s/\s\+$//e]])
		if cursor_position then
			vim.fn.setpos(".", cursor_position)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Easy quit help with 'q'",
	pattern = { "help" },
	callback = function()
		vim.keymap.set("n", "q", "<cmd>q<cr>", { silent = true, buffer = true })
		vim.keymap.set("n", "gd", "<C-]>", { silent = true, buffer = true })
	end,
})

