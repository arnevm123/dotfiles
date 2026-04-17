vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
vim.pack.add({
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})
vim.pack.add({ "https://github.com/smjonas/inc-rename.nvim" })

-- Mason
require("mason").setup({
	ui = { border = require("utils").borders() },
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

-- { mason_name, lsp_name } — leave "" for the side that doesn't apply
local tools = {
	-- LSP servers (mason-installed)
	{ "ansible-language-server", "ansiblels" },
	{ "bash-language-server", "bashls" },
	{ "copilot-language-server", "copilot" },
	{ "css-lsp", "cssls" },
	{ "docker-compose-language-service", "docker_compose_language_service" },
	{ "dockerfile-language-server", "dockerls" },
	{ "eslint-lsp", "eslint" },
	{ "html-lsp", "html" },
	{ "json-lsp", "jsonls" },
	{ "lua-language-server", "lua_ls" },
	{ "marksman", "marksman" },
	{ "pyright", "pyright" },
	{ "sqls", "sqls" },
	{ "typescript-language-server", "ts_ls" },
	{ "yaml-language-server", "yamlls" },
	-- { "ols", "ols" }, --odin
	-- { "zls", "zls" }, -- zig
	-- LSP servers (manually installed)
	{ "", "gopls" },
	{ "", "rust_analyzer" },
	-- Linters & formatters
	{ "ansible-lint", "" },
	{ "flake8", "" },
	{ "hlint", "" },
	{ "prettierd", "" },
	{ "selene", "" },
	{ "shellcheck", "" },
	{ "shfmt", "" },
	{ "stylua", "" },
	{ "yamlfmt", "" },
	{ "yamllint", "" },
}

local mason_pkgs = {}
local lsp_servers = {}
for _, tool in ipairs(tools) do
	if tool[1] ~= "" then table.insert(mason_pkgs, tool[1]) end
	if tool[2] ~= "" then table.insert(lsp_servers, tool[2]) end
end

require("mason-tool-installer").setup({ ensure_installed = mason_pkgs })

-- Diagnostic config
vim.diagnostic.config({
	virtual_text = { source = true },
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = { focusable = true, style = "minimal", source = true },
})

-- Inline completion
vim.lsp.inline_completion.enable(true)

-- Global LSP config: capabilities + on_attach
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

local on_attach = function(client, _) client.server_capabilities.semanticTokensProvider = nil end

vim.lsp.config("*", { on_attach = on_attach, capabilities = capabilities })

-- Enable all LSP servers
vim.lsp.enable(lsp_servers)

-- Inc-rename
require("inc_rename").setup({})

-- Keymaps
local map = require("keymaps").map
map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "LSP code action")
map("n", "<leader>lf", "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<CR>", "Format buffer")
map("n", "<leader>lr", ":IncRename <C-r><C-w>", "LSP rename variable", { silent = false })
map("n", "<leader>ld", "<cmd>lua require('utils').toggle_case_rename()<CR>", "LSP toggle case rename")
map("n", "<leader>ls", "<cmd>lua require('utils').lint_fix()<CR>", "LSP golangci-lint fix")
