-- LSP-adjacent: none-ls, fidget, rulebook (deferred)

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvimtools/none-ls.nvim",
})
vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })
vim.pack.add({ "https://github.com/chrisgrieser/nvim-rulebook" })
vim.pack.add({ "https://github.com/smjonas/inc-rename.nvim" })

-- none-ls
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.gomodifytags,
		null_ls.builtins.code_actions.impl,
		null_ls.builtins.code_actions.refactoring,
	},
})

-- fidget
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
			group_style = "@method",
			icon_style = "@method",
			format_message = function(msg)
				local message = msg.message
				if not message then message = msg.done and "✔" or "..." end
				if msg.percentage ~= nil then message = string.format("%.0f%%", msg.percentage) end
				return message
			end,
		},
		ignore = {},
	},
	notification = { window = { winblend = 100 } },
})

-- rulebook
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

-- Inc-rename
require("inc_rename").setup({})

-- Keymaps
local map = require("keymaps").map
map("n", "<Leader>le", "<cmd>lua require('rulebook').ignoreRule()<CR>", "Diagnostic: ignore rule")
map("n", "<Leader>ll", "<cmd>lua require('rulebook').lookupRule()<CR>", "Diagnostic: lookup rule")
map("n", "<Leader>ly", "<cmd>lua require('rulebook').lookupRule()<CR>", "Diagnostic: lookup rule (alt)")
map({ "n", "x" }, "<Leader>lo", "<cmd>lua require('rulebook').suppressFormatter()<CR>", "Diagnostic: suppress formatter")
