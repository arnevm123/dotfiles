vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" })
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", data = { build = "cargo build --release" } },
	"https://github.com/saghen/blink.compat",
})

require("blink.cmp").setup({
	cmdline = {
		completion = { menu = { draw = { columns = { { "label" } } } } },
		keymap = {
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-y>"] = { "select_and_accept" },
			["<C-p>"] = { "show_and_insert", "select_prev", "fallback" },
			["<C-n>"] = { "show_and_insert", "select_next", "fallback" },
			["<Tab>"] = { "show_and_insert", "select_next", "fallback" },
			["<S-Tab>"] = { "show_and_insert", "select_prev", "fallback" },
		},
	},
	snippets = { preset = "default" },
	keymap = {
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-y>"] = { "select_and_accept" },
		["<C-p>"] = { "show_and_insert", "select_prev", "fallback" },
		["<C-n>"] = { "show_and_insert", "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	completion = {
		keyword = { range = "prefix" },
		accept = { auto_brackets = { enabled = false } },
		menu = {
			border = "none",
			scrollbar = false,
			draw = {
				columns = { { "label", "label_description", gap = 1 }, { "kind_icon" }, { "source_name" } },
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 0,
		},
	},
	signature = { enabled = true },
	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
			"lazydev",
			"go_deep",
		},
		transform_items = function(_, items)
			for _, item in ipairs(items) do
				if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
					item.score_offset = item.score_offset - 3
				end
			end
			return items
		end,
		min_keyword_length = 0,
		providers = {
			lsp = { name = "[LSP]" },
			path = { name = "[PTH]" },
			buffer = { name = "[BFR]" },
			omni = { name = "[OMN]" },
			cmdline = { name = "[CMD]" },
			snippets = { name = "[SNP]", opts = { search_paths = { vim.fn.stdpath("config") .. "/snippets" } } },
			lazydev = { name = "[LZD]", module = "lazydev.integrations.blink", score_offset = 100 },
			go_deep = { name = "[GOD]", module = "blink.compat.source", opts = { cmp_name = "go_deep" } },
		},
	},
	fuzzy = { implementation = "rust" },
})
