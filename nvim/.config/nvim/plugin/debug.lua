vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/leoluz/nvim-dap-go",
	"https://github.com/igorlfs/nvim-dap-view",
})

-- dap-view
local function hl(text, group) return require("dap-view.util.statusline").hl(text, group, true, false) end
local function icon(name) return require("dap-view.setup").config.icons[name] end
local function hint(key) return hl(" [" .. key .. "]", "ControlNC") end

require("dap-view").setup({
	winbar = {
		sections = { "scopes", "watches", "exceptions", "breakpoints", "threads", "repl" },
		default_section = "scopes",
		controls = {
			enabled = true,
			custom_buttons = {
				play = {
					render = function(session)
						local pausable = session and not session.stopped_thread_id
						local i = hl(
							pausable and icon("pause") or icon("play"),
							pausable and "ControlPause" or "ControlPlay"
						)
						return i .. hint("F5")
					end,
					action = function()
						local dap = require("dap")
						local session = dap.session()
						local fn = session and not session.stopped_thread_id and dap.pause or dap.continue
						fn()
					end,
				},
				step_into = {
					render = function(session)
						local stopped = session and session.stopped_thread_id
						local i = hl(icon("step_into"), stopped and "ControlStepInto" or "ControlNC")
						return i .. hint("F4")
					end,
					action = function() require("dap").step_into() end,
				},
				step_over = {
					render = function(session)
						local stopped = session and session.stopped_thread_id
						local i = hl(icon("step_over"), stopped and "ControlStepOver" or "ControlNC")
						return i .. hint("F3")
					end,
					action = function() require("dap").step_over() end,
				},
				step_out = {
					render = function(session)
						local stopped = session and session.stopped_thread_id
						local i = hl(icon("step_out"), stopped and "ControlStepOut" or "ControlNC")
						return i .. hint("F2")
					end,
					action = function() require("dap").step_out() end,
				},
				step_back = {
					render = function(session)
						local stopped = session and session.stopped_thread_id
						local i = hl(icon("step_back"), stopped and "ControlStepBack" or "ControlNC")
						return i .. hint("F1")
					end,
					action = function() require("dap").step_back() end,
				},
				run_last = {
					render = function() return hl(icon("run_last"), "ControlRunLast") .. hint("F6") end,
					action = function() require("dap").run_last() end,
				},
				terminate = {
					render = function(session)
						local i = hl(icon("terminate"), session and "ControlTerminate" or "ControlNC")
						return i .. hint("F7")
					end,
					action = function() require("dap").terminate() end,
				},
				disconnect = {
					render = function(session)
						local i = hl(icon("disconnect"), session and "ControlDisconnect" or "ControlNC")
						return i .. hint("F8")
					end,
					action = function() require("dap").disconnect() end,
				},
			},
		},
	},
})

-- dap-go
require("dap-go").setup({})

-- Keymaps
local keymap = vim.keymap.set
keymap("n", "<F5>", "<cmd>lua require('dap').continue()<CR>", { desc = "Debug continue" })
keymap("n", "<F4>", "<cmd>lua require('dap').step_into()<CR>", { desc = "Debug step into" })
keymap("n", "<F3>", "<cmd>lua require('dap').step_over()<CR>", { desc = "Debug step over" })
keymap("n", "<F2>", "<cmd>lua require('dap').step_out()<CR>", { desc = "Debug step out" })
keymap("n", "<F1>", "<cmd>lua require('dap').step_back()<CR>", { desc = "Debug step back" })
keymap("n", "<F6>", "<cmd>lua require('dap').run_last()<CR>", { desc = "Debug run last" })
keymap("n", "<F7>", "<cmd>lua require('dap').terminate()<CR>", { desc = "Debug terminate" })
keymap("n", "<F8>", "<cmd>lua require('dap').disconnect()<CR>", { desc = "Debug disconnect" })
keymap("n", "<leader>dc", "<cmd>lua require('dap').run_to_cursor()<CR>", { desc = "Debug run to cursor" })
keymap("n", "<leader>du", "<cmd>lua require('dap').up()<CR>", { desc = "Debug step up callstack" })
keymap("n", "<leader>dd", "<cmd>lua require('dap').down()<CR>", { desc = "Debug step down callstack" })
keymap("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Debug toggle breakpoint" })
keymap("n", "<leader>dv", "<cmd>DapViewToggle<CR>", { desc = "Debug Show" })
keymap("n", "<leader>dw", "<cmd>DapViewWatch<CR>", { desc = "Debug preview" })
