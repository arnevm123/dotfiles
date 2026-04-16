-- Treesitter + context + textobjects + matchup (eager, no deferral)
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
vim.pack.add({ "https://github.com/andymass/vim-matchup" })
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-context" })
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" })

-- Build step for treesitter
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
			if ev.data.active then vim.cmd("TSUpdate") end
		end
	end,
})

-- matchup
vim.g.matchup_matchparen_offscreen = {}
vim.g.no_plugin_maps = true

-- Treesitter: eager setup using new nvim-treesitter API + vim.treesitter
-- Install parsers (async, runs in background)
local parsers_to_install = {
	"bash",
	"c",
	"comment",
	"css",
	"csv",
	"diff",
	"dockerfile",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"gowork",
	"haskell",
	"html",
	"http",
	"ini",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"make",
	"markdown",
	"markdown_inline",
	"nix",
	"proto",
	"python",
	"query",
	"regex",
	"rst",
	"rust",
	"scss",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"vue",
	"xml",
	"yaml",
	"zig",
}

-- Install missing parsers on startup
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local installed = require("nvim-treesitter.config").get_installed("parsers")
		local installed_set = {}
		for _, p in ipairs(installed) do
			installed_set[p] = true
		end
		local missing = {}
		for _, p in ipairs(parsers_to_install) do
			if not installed_set[p] then table.insert(missing, p) end
		end
		if #missing > 0 then require("nvim-treesitter").install(missing) end
	end,
})

-- Enable treesitter highlighting/folding/indentation per buffer
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter.start", {}),
	callback = function(args)
		local buf = args.buf
		local filetype = args.match
		local language = vim.treesitter.language.get_lang(filetype) or filetype
		local ok = pcall(vim.treesitter.language.add, language)
		if not ok then return end
		local started = pcall(vim.treesitter.start, buf, language)
		if not started then return end
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Treesitter context (deferred)
require("treesitter-context").setup({
	enable = true,
	max_lines = 5,
	trim_scope = "inner",
	min_window_height = 0,
	patterns = { default = { "class", "function", "method", "for", "while", "if", "switch", "case" } },
	zindex = 20,
	mode = "cursor",
	separator = nil,
})

-- Treesitter textobjects (deferred)
require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@function.outer"] = "V",
			["@class.outer"] = "<c-v>",
		},
		include_surrounding_whitespace = false,
	},
})

local keymap = vim.keymap.set
keymap(
	{ "x", "o" },
	"af",
	function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end,
	{ desc = "Select outer function" }
)
keymap(
	{ "x", "o" },
	"if",
	function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end,
	{ desc = "Select inner function" }
)
keymap(
	"n",
	"[e",
	function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end,
	{ desc = "Swap next param" }
)
keymap(
	"n",
	"]e",
	function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer") end,
	{ desc = "Swap prev param" }
)
keymap(
	{ "n", "x", "o" },
	"]f",
	function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end,
	{ desc = "Next function start" }
)
keymap(
	{ "n", "x", "o" },
	"[F",
	function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end,
	{ desc = "Prev function end" }
)
keymap(
	{ "n", "x", "o" },
	"[f",
	function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end,
	{ desc = "Prev function start" }
)
keymap(
	{ "n", "x", "o" },
	"]F",
	function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end,
	{ desc = "Next function end" }
)
