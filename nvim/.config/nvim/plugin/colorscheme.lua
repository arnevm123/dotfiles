-- Colorschemes + UI appearance

vim.pack.add({
	"https://github.com/rktjmp/lush.nvim",
	"https://github.com/mcchrish/zenbones.nvim",
})
vim.pack.add({ "https://github.com/vague2k/vague.nvim" })
vim.pack.add({ "https://github.com/ramojus/mellifluous.nvim" })

-- devicons
vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
require("nvim-web-devicons").setup({ color_icons = false })

-- colorizer
vim.pack.add({ "https://github.com/catgoose/nvim-colorizer.lua" })
require("colorizer").setup()
vim.pack.add({ "https://github.com/kyzabuilds/xeno.nvim" })

local colorscheme = "seoulbones"
-- local colorscheme = "vague"
-- local colorscheme = "mel"
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
	vim.api.nvim_set_hl(0, "ImportNamespace", { italic = true })
	vim.api.nvim_set_hl(0, "@lsp.type.namespace", { link = "ImportNamespace" })
elseif colorscheme == "vague" then
	require("vague").setup({ transparent = false })
	vim.cmd.colorscheme("vague")
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
elseif colorscheme == "xeno" then
	local xeno = require("xeno")

	-- Method 1: Use xeno.setup() for direct configuration
	xeno.setup({
		transparent = true,
	})

	xeno.color("rust", "#b5622f")
	xeno.color("amber", "#c99a3f")
	xeno.color("brick", "#a4453c")
	xeno.color("umber", "#7a5c42")
	xeno.color("olive", "#6f7a4a")
	xeno.color("moss", "#8a9463")

	xeno.theme("metal", {
		background = "#2b2d2e",
		accent = "#c17a3d",
		foreground = "#c6cac7",
		properties = { contrast = -0.15, chroma = -0.15, lightness = -0.05 },

		highlights = {
			editor = {
				CursorLineNr = { fg = "@amber.100", bold = true },
				MatchParen = { fg = "@brick.100", bold = true },
			},
			syntax = {
				Comment = { fg = "@foreground.400", italic = true },
				Keyword = { fg = "@umber.300" },
				Conditional = { fg = "@brick.300" },
				Function = { fg = "@amber.300" },
				Type = { fg = "@rust.200" },
				String = { fg = "@olive.100" },
				Number = { fg = "@amber.100" },
				Boolean = { fg = "@amber.100" },
				Variable = { fg = "@foreground.300" },
				Property = { fg = "@moss.300" },
				Operator = { fg = "@rust.300" },
				Punctuation = { fg = "@foreground.400" },

				["@keyword"] = { link = "Keyword" },
				["@keyword.return"] = { link = "Keyword" },
				["@keyword.function"] = { link = "Conditional" },
				["@keyword.conditional"] = { link = "Conditional" },
				["@keyword.repeat"] = { link = "Conditional" },
				["@keyword.operator"] = { fg = "@rust.300" },
				["@keyword.import"] = { fg = "@umber.400" },

				["@function"] = { link = "Function" },
				["@function.builtin"] = { fg = "@amber.100" },
				["@type"] = { link = "Type" },
				["@string"] = { link = "String" },
				["@string.escape"] = { fg = "@amber.100" },
				["@number"] = { link = "Number" },
				["@boolean"] = { link = "Boolean" },
				["@constant"] = { fg = "@amber.100" },
				["@constant.builtin"] = { fg = "@amber.100", bold = true },

				["@variable"] = { link = "Variable" },
				["@variable.builtin"] = { fg = "@brick.200" },
				["@property"] = { link = "Property" },
				["@constructor"] = { fg = "@foreground.400" },
				["@lsp.type.variable"] = { link = "@variable" },
				["@lsp.type.property"] = { link = "@property" },
				["@lsp.mod.declaration"] = { clear = true },

				["@operator"] = { link = "Operator" },
				["@punctuation"] = { link = "Punctuation" },
				["@punctuation.bracket"] = { link = "Punctuation" },
				["@punctuation.delimiter"] = { link = "Punctuation" },
			},
		},
	})
	vim.cmd.colorscheme("latte-express")
end
