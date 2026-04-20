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

table.insert(require("dap").configurations.go, 1, {
	type = "go",
	request = "attach",
	name = "Attach to .pidfile",
	mode = "local",
	processId = function()
		local pidfile = vim.fn.getcwd() .. "/.pidfile"
		local ok, content = pcall(vim.fn.readfile, pidfile)
		local pid = ok and content[1] and tonumber(vim.trim(content[1]))
		if not pid then
			vim.notify("No valid PID in " .. pidfile, vim.log.levels.ERROR)
			return nil
		end
		return pid
	end,
})

-- Keymaps
local map = require("keymaps").map
map("n", "<F5>", function() require("dap").continue() end, "Debug continue")
map("n", "<F4>", function() require("dap").step_into() end, "Debug step into")
map("n", "<F3>", function() require("dap").step_over() end, "Debug step over")
map("n", "<F2>", function() require("dap").step_out() end, "Debug step out")
map("n", "<F1>", function() require("dap").step_back() end, "Debug step back")
map("n", "<F6>", function() require("dap").run_last() end, "Debug run last")
map("n", "<F7>", function() require("dap").terminate() end, "Debug terminate")
map("n", "<F8>", function() require("dap").disconnect() end, "Debug disconnect")
map("n", "<leader>dc", function() require("dap").run_to_cursor() end, "Debug run to cursor")
map("n", "<leader>du", function() require("dap").up() end, "Debug step up callstack")
map("n", "<leader>dd", function() require("dap").down() end, "Debug step down callstack")
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", "Debug toggle breakpoint")
map("n", "<leader>dv", "<cmd>DapViewToggle<CR>", "Debug view toggle")
map("n", "<leader>dw", "<cmd>DapViewWatch<CR>", "Debug watch expression")
