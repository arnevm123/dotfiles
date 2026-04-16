vim.pack.add({
	"https://github.com/rktjmp/lush.nvim",
	"https://github.com/mcchrish/zenbones.nvim",
})
vim.pack.add({ "https://github.com/vague2k/vague.nvim" })
vim.pack.add({ "https://github.com/ramojus/mellifluous.nvim" })

local colorscheme = "seoulbones"
if colorscheme == "seoulbones" then
	vim.cmd.colorscheme("seoulbones")
	require("utils").remove_bg()
	vim.api.nvim_set_hl(0, "@text.title.gitcommit", { link = "Constant" })
	vim.api.nvim_set_hl(0, "Visual", { bg = "#3B3B3B" })
	vim.api.nvim_set_hl(0, "VisualNonText", { fg = "#5B5B5B", bg = "#3B3B3B" })
	vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#4B4B4B" })
	vim.api.nvim_set_hl(0, "comment", { fg = "#8B8B8B", italic = true })
	vim.api.nvim_set_hl(0, "IncSearch", { bg = "#6B6B6B" })
	vim.api.nvim_set_hl(0, "Search", { bg = "#4B4B4B" })
	vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#4B4B4B" })
	vim.api.nvim_set_hl(0, "netrwDir", { link = "DiagnosticVirtualTextInfo" })
	vim.api.nvim_set_hl(0, "ModeMsg", { link = "DiagnosticVirtualTextHint" })
	vim.api.nvim_set_hl(0, "@string", { link = "Constant" })
elseif colorscheme == "vague" then
	require("vague").setup({ transparent = false })
	vim.cmd.colorscheme("vague")
	vim.api.nvim_set_hl(0, "HarpoonWindow", { bg = "#333333" })
	vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#333333" })
	vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#555555" })
	local visual_bg = vim.api.nvim_get_hl(0, { name = "Visual" }).bg
	vim.api.nvim_set_hl(0, "VisualNonText", { fg = "#5B5B5B", bg = visual_bg })
elseif colorscheme == "mel" then
	require("mellifluous").setup({
		color_set = "mellifluous",
		styles = {
			comments = { italic = true },
			conditionals = { italic = true },
			loops = { italic = true },
			functions = { italic = true },
			keywords = { italic = true },
			strings = { italic = true },
		},
		flat_background = {
			line_numbers = true,
			floating_windows = false,
			file_tree = false,
			cursor_line_number = true,
		},
		plugins = { gitsigns = true },
	})
	vim.cmd.colorscheme("mellifluous")
	vim.api.nvim_set_hl(0, "@text.title.gitcommit", { link = "Constant" })
	vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#333333" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#DDDDDD", bg = "NONE" })
	vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { bg = "#333322" })
	local visual_bg = vim.api.nvim_get_hl(0, { name = "Visual" }).bg
	vim.api.nvim_set_hl(0, "VisualNonText", { fg = "#5B5B5B", bg = visual_bg })
	vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#4B4B4B" })
	local float_bg = vim.api.nvim_get_hl(0, { name = "NormalFloat" }).bg
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = float_bg })
end
