-- Git commit message diagnostics for Neovim
-- Visual feedback only:
--   * Warn if subject > 50 chars
--   * Warn if second line is not blank
--   * 72 char body guidance

local buf = vim.api.nvim_get_current_buf()

-- =========================
-- Buffer-local options
-- =========================
vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = "73"
vim.opt_local.formatoptions:append("tcqaw")

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

-- =========================
-- Namespaces
-- =========================
local ns_overflow = vim.api.nvim_create_namespace("gitcommit_overflow")
local ns_warn = vim.api.nvim_create_namespace("gitcommit_warning")

-- =========================
-- Highlight groups
-- =========================
vim.api.nvim_set_hl(0, "GitCommitOverflow", {
	fg = "#ff5555",
	underline = true,
})

-- =========================
-- Subject overflow highlight
-- =========================
local function highlight_subject_overflow()
	vim.api.nvim_buf_clear_namespace(buf, ns_overflow, 0, -1)

	local subject = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
	if not subject or #subject <= 50 then return end

	vim.api.nvim_buf_set_extmark(buf, ns_overflow, 0, 50, {
		end_row = 0,
		end_col = #subject,
		hl_group = "GitCommitOverflow",
	})
end

-- =========================
-- Virtual warnings
-- =========================
local function show_warnings()
	vim.api.nvim_buf_clear_namespace(buf, ns_warn, 0, -1)

	local lines = vim.api.nvim_buf_get_lines(buf, 0, 2, false)
	local subject = lines[1] or ""
	local second = lines[2] or ""

	-- Subject length warning
	if #subject > 50 then
		vim.api.nvim_buf_set_extmark(buf, ns_warn, 0, -1, {
			virt_text = {
				{ " ✖ Subject exceeds 50 characters", "ErrorMsg" },
			},
			virt_text_pos = "eol",
		})
	end

	-- Second line should be blank
	if subject ~= "" and second ~= "" and not second:match("^%s*#") then
		vim.api.nvim_buf_set_extmark(buf, ns_warn, 1, -1, {
			virt_text = {
				{ " ✖ Second line should be blank", "ErrorMsg" },
			},
			virt_text_pos = "eol",
		})
	end
end

-- =========================
-- Autocommands
-- =========================
local augroup = vim.api.nvim_create_augroup("GitCommitDiagnostics", { clear = true })

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
	group = augroup,
	buffer = buf,
	callback = function()
		highlight_subject_overflow()
		show_warnings()
	end,
})
