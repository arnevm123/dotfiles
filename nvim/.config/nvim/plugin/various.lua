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
map({ "n", "x" }, "ga.", "<cmd>lua require('utils').try_lsp_rename()<CR>", "Rename (textcase picker)")
map({ "n", "x" }, "gau", "<cmd>lua require('utils').try_lsp_rename('to_constant_case')<CR>", "Rename to CONSTANT_CASE")
map({ "n", "x" }, "gas", "<cmd>lua require('utils').try_lsp_rename('to_snake_case')<CR>", "Rename to snake_case")
map({ "n", "x" }, "gad", "<cmd>lua require('utils').try_lsp_rename('to_dash_case')<CR>", "Rename to dash-case")
map({ "n", "x" }, "gac", "<cmd>lua require('utils').try_lsp_rename('to_camel_case')<CR>", "Rename to camelCase")
map({ "n", "x" }, "gap", "<cmd>lua require('utils').try_lsp_rename('to_pascal_case')<CR>", "Rename to PascalCase")

-- grug-far
map("n", "<leader>ss", "<cmd>lua require('grug-far').open()<CR>", "Grug-far search and replace")
map("x", "<leader>ss", "<cmd>lua require('grug-far').with_visual_selection()<CR>", "Grug-far replace selection")

-- treesj
map("n", "<space>ej", "<cmd>lua require('treesj').join()<CR>", "Join lines")
map("n", "<space>ek", "<cmd>lua require('treesj').split()<CR>", "Split lines")

-- atone
map("n", "<leader>eu", "<cmd>Atone toggle<CR>", "Atone toggle")
