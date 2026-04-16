vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
	formatters = {
		sqlffluf = {
			command = "sqlfluff",
			args = { "fix", "--dialect=mysql", "-" },
			stdin = true,
		},
		["golangci-lint"] = { prepend_args = { "--config", "~/.config/linters/golangci.yaml" } },
	},
	formatters_by_ft = {
		go = { "golangci-lint" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		lua = { "stylua" },
		markdown = { "mdslw" },
		sh = { "shfmt" },
		mysql = { "sqlffluf" },
		sql = { "sqlffluf" },
		python = { "isort", "black" },
	},
})
