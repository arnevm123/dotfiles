-- LSP-adjacent: none-ls, fidget, rulebook

-- none-ls
vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvimtools/none-ls.nvim",
})
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.gomodifytags,
		null_ls.builtins.code_actions.impl,
		null_ls.builtins.code_actions.refactoring,
	},
})

-- fidget
vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })
require("fidget").setup({
	progress = {
		suppress_on_insert = true,
		ignore_done_already = true,
		display = {
			done_ttl = 1,
			done_icon = "",
			done_style = "Comment",
			progress_style = "Comment",
			progress_ttl = 30,
			group_style = "@function",
			icon_style = "@function",
			format_message = function(msg)
				local message = msg.message
				if not message then message = msg.done and "✔" or "󰲽" end
				if msg.percentage ~= nil then message = string.format("%.0f%%", msg.percentage) end
				return message
			end,
		},
		ignore = {},
	},
	notification = { window = { winblend = 100 } },
})

-- rulebook
vim.pack.add({ "https://github.com/chrisgrieser/nvim-rulebook" })
require("rulebook").setup({ ---@diagnostic disable-line: missing-fields
	forwSearchLines = 10,
	ignoreComments = {
		shellcheck = { ---@diagnostic disable-line: missing-fields
			comment = "# shellcheck disable=%s",
			location = "prevLine",
			multiRuleIgnore = true,
			multiRuleSeparator = ",",
		},
		["golangci-lint"] = { ---@diagnostic disable-line: missing-fields
			comment = "//nolint:%s",
			location = "sameLine",
			multiRuleIgnore = true,
			multiRuleSeparator = ",",
		},
	},
	ruleDocs = {
		fallback = function(diag)
			local line = vim.api.nvim_buf_get_lines(diag.bufnr, diag.lnum, diag.lnum + 1, false)[1]
			return "https://chatgpt.com/?q=Explain%20the%20following%20diagnostic%20error%3A%20"
				.. diag.message
				.. "%0AOffending line%3A%0A"
				.. line
				.. "%0A"
		end,
	},
})

-- Keymaps
local map = require("keymaps").map
map("n", "<leader>le", function() require("rulebook").ignoreRule() end, "Diagnostic: ignore rule")
map("n", "<leader>ll", function() require("rulebook").lookupRule() end, "Diagnostic: lookup rule")
map("n", "<leader>ly", function() require("rulebook").lookupRule() end, "Diagnostic: lookup rule (alt)")
map(
	{ "n", "x" },
	"<leader>lo",
	function() require("rulebook").suppressFormatter() end,
	"Diagnostic: suppress formatter"
)

vim.pack.add({ "https://github.com/error311/wayfinder.nvim" })
require("wayfinder").setup({})
vim.keymap.set("n", "gw", "<Plug>(WayfinderOpen)", { desc = "Wayfinder" })

vim.pack.add({ "https://github.com/leolaurindo/tunnelvision.nvim" })
require("tunnelvision").setup()

map("n", "<leader>lv", "<cmd>TunnelVision toggle<CR>", "TunnelVision: toggle")
map("n", "<leader>ln", "<cmd>TunnelVision next<CR>", "TunnelVision: next")
map("n", "<leader>lp", "<cmd>TunnelVision previous<CR>", "TunnelVision: previous")
