-- Linting: nvim-lint

vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

lint.linters_by_ft = {
	go = { "golangcilint", "cspell" },
	lua = { "selene" },
	haskell = { "hlint" },
	python = { "ruff" },
	sh = { "shellcheck" },
	typescript = { "eslint_d" },
	gitcommit = { "commitlint" },
	NeogitCommitMessage = { "commitlint" },
	markdown = { "cspell" },
	["yaml.ansible"] = { "ansible_lint" },
}

-- Fidget integration for linter progress
local function fidget_linters(h)
	local handlers = h or {}
	local linters = lint.get_running(0)
	if #linters == 0 then
		for _, handle in pairs(handlers) do
			handle:finish()
		end
		return
	end
	for _, linter in ipairs(linters) do
		if not handlers[linter] then
			handlers[linter] = require("fidget.progress").handle.create({
				title = "",
				message = "",
				lsp_client = { name = linter },
			})
		end
	end
	for lntr, handle in pairs(handlers) do
		if not vim.tbl_contains(linters, lntr) then handle:finish() end
	end
	vim.defer_fn(function() fidget_linters(handlers) end, 50)
end

-- Defer linter customization to avoid synchronous binary execution at startup
local configured = false
local function configure_linters()
	if configured then return end
	configured = true

	-- Custom golangcilint parser: swap source/code
	local golangci_parser = lint.linters.golangcilint.parser
	lint.linters.golangcilint.parser = function(output, bufnr, cwd)
		local diagnostics = golangci_parser(output, bufnr, cwd)
		for _, diag in ipairs(diagnostics) do
			diag.code = diag.source
			diag.source = "golangci-lint"
		end
		return diagnostics
	end
	table.insert(lint.linters.golangcilint.args, "--config")
	table.insert(lint.linters.golangcilint.args, "~/.config/linters/golangci.yaml")

	lint.linters.commitlint.args = {
		"--config",
		require("utils").git_cwd() .. "pyproject.toml",
	}
	lint.linters.cspell.args = {
		"lint",
		"--no-color",
		"--no-progress",
		"--no-summary",
		"--config",
		"~/.config/linters/cspell.json",
		"--gitignore",
	}

	-- Custom diagnostic config per namespace
	local ns = lint.get_namespace("cspell")
	vim.diagnostic.config({ virtual_text = false }, ns)

	local gc_format = function(diag)
		local src = diag.code and tostring(diag.code) or diag.source or ""
		return src .. ": " .. diag.message
	end
	local ns_gc = lint.get_namespace("golangcilint")
	vim.diagnostic.config({
		virtual_text = { source = false, format = gc_format },
		float = { source = false, format = gc_format },
	}, ns_gc)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("lint", { clear = true }),
	callback = function()
		configure_linters()
		lint.try_lint()
		fidget_linters()
	end,
})
