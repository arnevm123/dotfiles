-- Comment
vim.pack.add({ "https://github.com/numToStr/Comment.nvim" })
require("Comment").setup()
require("Comment.ft").set("mysql", { "--%s", "/*%s*/" })

-- treesj
vim.pack.add({ "https://github.com/Wansmer/treesj" })
require("treesj").setup({ use_default_keymaps = false })

-- text-case
vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
})
vim.pack.add({ "https://github.com/johmsalas/text-case.nvim" })
require("textcase").setup({ substitude_command_name = "S", default_keymappings_enabled = false })
require("telescope").load_extension("textcase")

-- atone
vim.pack.add({ "https://github.com/XXiaoA/atone.nvim" })
require("atone").setup({})

-- Keymaps
local map = require("keymaps").map

-- text-case
map({ "n", "x" }, "ga.", function() require("utils").try_lsp_rename() end, "Rename (textcase picker)")
map({ "n", "x" }, "gau", function() require("utils").try_lsp_rename("to_constant_case") end, "Rename to CONSTANT_CASE")
map({ "n", "x" }, "gas", function() require("utils").try_lsp_rename("to_snake_case") end, "Rename to snake_case")
map({ "n", "x" }, "gad", function() require("utils").try_lsp_rename("to_dash_case") end, "Rename to dash-case")
map({ "n", "x" }, "gac", function() require("utils").try_lsp_rename("to_camel_case") end, "Rename to camelCase")
map({ "n", "x" }, "gap", function() require("utils").try_lsp_rename("to_pascal_case") end, "Rename to PascalCase")

-- treesj
map("n", "<leader>ej", function() require("treesj").join() end, "Join lines")
map("n", "<leader>ek", function() require("treesj").split() end, "Split lines")

-- atone
map("n", "<leader>eu", "<cmd>Atone toggle<CR>", "Atone toggle")
