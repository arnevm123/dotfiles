-- Various editing plugins (deferred)

-- Eager loads (no setup needed or needed early)
vim.pack.add({ "https://github.com/wsdjeg/vim-fetch" })
vim.pack.add({ "https://github.com/lambdalisue/vim-suda" })
vim.pack.add({ "https://github.com/tpope/vim-eunuch" })
vim.pack.add({ "https://github.com/tpope/vim-dispatch" })
vim.pack.add({ "https://github.com/chrisbra/csv.vim" })

vim.pack.add({ "https://github.com/esmuellert/codediff.nvim" })

-- Deferred plugins
vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
})
vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
vim.pack.add({ "https://github.com/catgoose/nvim-colorizer.lua" })
vim.pack.add({ "https://github.com/pearofducks/ansible-vim" })
vim.pack.add({ "https://github.com/johmsalas/text-case.nvim" })
vim.pack.add({ "https://github.com/numToStr/Comment.nvim" })
vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })
vim.pack.add({ "https://github.com/Wansmer/treesj" })
vim.pack.add({ "https://github.com/XXiaoA/atone.nvim" })

-- devicons
require("nvim-web-devicons").setup({ color_icons = false })

-- colorizer
require("colorizer").setup()

-- text-case
require("textcase").setup({ substitude_command_name = "S", default_keymappings_enabled = false })
require("telescope").load_extension("textcase")

-- Comment
require("Comment").setup()
require("Comment.ft").set("mysql", { "--%s", "/*%s*/" })

-- grug-far
require("grug-far").setup({
	startInInsertMode = false,
	transient = true,
})

-- treesj
require("treesj").setup({ use_default_keymaps = false })

-- atone
require("atone").setup({})

-- text-case
local map = require("keymaps").map
map({ "n", "x" }, "ga.", function() require("utils").try_lsp_rename() end, "Rename (textcase picker)")
map({ "n", "x" }, "gau", function() require("utils").try_lsp_rename("to_constant_case") end, "Rename to CONSTANT_CASE")
map({ "n", "x" }, "gas", function() require("utils").try_lsp_rename("to_snake_case") end, "Rename to snake_case")
map({ "n", "x" }, "gad", function() require("utils").try_lsp_rename("to_dash_case") end, "Rename to dash-case")
map({ "n", "x" }, "gac", function() require("utils").try_lsp_rename("to_camel_case") end, "Rename to camelCase")
map({ "n", "x" }, "gap", function() require("utils").try_lsp_rename("to_pascal_case") end, "Rename to PascalCase")

-- grug-far
map("n", "<leader>ss", function() require("grug-far").open() end, "Grug-far search and replace")
map("x", "<leader>ss", function() require("grug-far").with_visual_selection() end, "Grug-far replace selection")

-- treesj
map("n", "<leader>ej", function() require("treesj").join() end, "Join lines")
map("n", "<leader>ek", function() require("treesj").split() end, "Split lines")

-- atone
map("n", "<leader>eu", "<cmd>Atone toggle<CR>", "Atone toggle")
