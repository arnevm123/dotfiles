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

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local nosilent = { noremap = true }
keymap("n", "<leader>bu", function() run_compile("make build") end, nosilent)
keymap("n", "<leader>bt", function() run_compile("make test") end, nosilent)
keymap("n", "<leader>bl", function() run_compile("make lint") end, nosilent)
keymap("n", "<leader>bg", function() run_compile() end, nosilent)
keymap("n", "<leader>br", function() run_compile("LOG_LEVEL=trace make run") end, nosilent)
keymap("n", "<leader>be", function() run_compile("recompile") end, nosilent)
keymap("n", "]x", function() require("compile-mode").next_error() end, opts)
keymap("n", "[x", function() require("compile-mode").prev_error() end, opts)
keymap("n", "<leader>bd", ":silent! execute 'bdelete' bufname('*compilation*')<CR>", opts)
keymap("n", "yox", function()
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
end, { noremap = true, silent = true, desc = "Toggle compilation buffer" })
keymap("n", "<leader>bq", ":silent! execute 'bdelete' bufname('*compilation*')<CR>:QuickfixErrors<CR>", opts)
