vim.pack.add({
	"https://github.com/m00qek/baleia.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/ej-shafran/compile-mode.nvim",
})

local function get_build_root()
	local ok, clients = pcall(vim.lsp.get_clients)
	if not ok or not clients or #clients == 0 then return nil end
	local root = clients[1].config and clients[1].config.cmd_cwd
	if root and vim.fn.isdirectory(root) == 1 then return root end
	return nil
end
local function run_compile(cmd)
	vim.g.compilation_directory = get_build_root()
	if not cmd then
		vim.cmd("below 15 Compile")
	elseif cmd == "recompile" then
		vim.cmd("below 15 Recompile")
	else
		vim.cmd("below 15 Compile " .. cmd)
	end
end

---@module "compile-mode"
---@type CompileModeOpts
vim.g.compile_mode = {
	default_command = "",
	baleia_setup = true,
	bang_expansion = true,
	error_ignore_file_list = { "Makefile$", "makefile$", "GNUmakefile$" },
	hidden_output = "\\v^(\\d{2}-\\d{2}-\\d{4} )",
	error_regexp_table = {
		["00-rust"] = {
			regex = "^\\s*--> \\([^:]\\+\\):\\(\\d\\+\\):\\(\\d\\+\\)",
			filename = 1,
			row = 2,
			col = 3,
		},
		go_logs = {
			regex = "\\v.*\\[(.+):([0-9]+)\\]",
			filename = 1,
			row = 2,
		},
	},
	focus_compilation_buffer = true,
}

local map = require("keymaps").map
map("n", "<leader>bu", function() run_compile("make build") end, "Compile: make build", { silent = false })
map("n", "<leader>bt", function() run_compile("make test") end, "Compile: make test", { silent = false })
map("n", "<leader>bl", function() run_compile("make lint") end, "Compile: make lint", { silent = false })
map("n", "<leader>bg", function() run_compile() end, "Compile: prompt command", { silent = false })
map("n", "<leader>br", function() run_compile("LOG_LEVEL=trace make run") end, "Compile: make run", { silent = false })
map("n", "<leader>be", function() run_compile("recompile") end, "Compile: recompile", { silent = false })
map("n", "]x", function() require("compile-mode").next_error() end, "Next compile error")
map("n", "[x", function() require("compile-mode").prev_error() end, "Previous compile error")
map("n", "<leader>bd", ":silent! execute 'bdelete' bufname('*compilation*')<CR>", "Delete compilation buffer")
map("n", "yox", function()
	local bufnr = vim.g.compilation_buffer
	if not bufnr then
		vim.notify("Compilation buffer not found", vim.log.levels.WARN)
		return
	end
	local winid = vim.fn.bufwinid(bufnr)
	if winid == -1 then
		vim.cmd("belowright 15 split")
		vim.cmd("buffer " .. bufnr)
	else
		vim.api.nvim_win_close(winid, false)
	end
end, "Toggle compilation buffer")
map("n", "<leader>bq", ":silent! execute 'bdelete' bufname('*compilation*')<CR>:QuickfixErrors<CR>", "Compile errors to quickfix")
