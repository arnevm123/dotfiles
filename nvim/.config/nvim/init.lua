vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('vim._core.ui2').enable({
    enable = true,
    msg = {
        target = "cmd", -- options: cmd(classic), msg(similar to noice)
        pager = { height = 0.5 },
        dialog = { height = 0.5 },
        cmd    = { height = 0.5 },
        msg   = { height = 0.5, timeout = 4500 },
    },
})

require("options")
require("filetypes")
require("keymaps")
require("autocommand")
require("usercommands")
require("statusline")
