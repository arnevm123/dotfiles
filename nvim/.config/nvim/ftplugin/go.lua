vim.opt_local.expandtab = false
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

vim.cmd.compiler("go")
vim.b.dispatch = "go test ./... -coverprofile=.coverage.out"
