vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.messagesopt:append("timeout:4500")

require('vim._core.ui2').enable({
    enable = true,
    msg = {
        targets = "cmd", -- options: cmd(classic), msg(similar to noice)
        pager = { height = 0.5 },
        dialog = { height = 0.5 },
        msg = { height = 0.5 },
    },
})

require("pack")
require("options")
require("filetypes")
require("keymaps")
require("autocommand")
require("usercommands")
require("statusline")
