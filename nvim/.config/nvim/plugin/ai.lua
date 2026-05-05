-- AI: opencode.nvim + 99.nvim

vim.pack.add({
	"https://github.com/saghen/blink.compat",
	"https://github.com/ThePrimeagen/99",
})

local _99 = require("99")
local cwd = vim.uv.cwd()
local basename = vim.fs.basename(cwd)
_99.setup({
	provider = _99.Providers.OpenCodeProvider,
	model = "opencode/big-pickle",
	logger = {
		level = _99.DEBUG,
		path = "/tmp/" .. basename .. ".99.debug",
		print_on_error = true,
	},
	tmp_dir = "./tmp",
	completion = {
		custom_rules = { "scratch/custom_rules/" },
		files = {},
		source = "blink",
	},
	md_files = { "AGENT.md" },
	in_flight_options = { enable = false },
})

local map = require("keymaps").map
map("n", "<leader>af", require("utils").ai_fix_lint, "AI fix linting")
map("n", "<leader>ax", function() _99.stop_all_requests() end, "AI stop requests")
map("v", "<leader>ai", function()
	_99.visual({})
	vim.cmd("startinsert")
end, "AI visual replace")
map("n", "<leader>as", function()
	_99.search({})
	vim.cmd("startinsert")
end, "AI search")

vim.pack.add({
	"https://github.com/nickjvandyke/opencode.nvim",
})

vim.o.autoread = true -- required for buffer reload on opencode edits

---@type opencode.Opts
vim.g.opencode_opts = {
	server = {
		start = false,
		stop = false,
		toggle = false,
	},
}

map({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ", { submit = true }) end, "Ask opencode")
map({ "n", "x" }, "<leader>ap", function() require("opencode").select() end, "Opencode actions")

-- Show 99.nvim progress in fidget.nvim
local function fidget_99(handles)
	handles = handles or {}
	local state = _99.__get_state()
	if not state then return end

	local active = state.tracking:active()
	local counts = {}
	for _, ctx in ipairs(active) do
		counts[ctx.operation] = (counts[ctx.operation] or 0) + 1
	end

	for op, handle in pairs(handles) do
		if not counts[op] then
			handle:finish()
			handles[op] = nil
		end
	end

	for op, count in pairs(counts) do
		local msg = count > 1 and op .. " (" .. count .. ")" or op
		if not handles[op] then
			handles[op] = require("fidget.progress").handle.create({
				title = "",
				message = msg,
				lsp_client = { name = "99" },
			})
		else
			handles[op].message = msg
		end
	end

	vim.defer_fn(function() fidget_99(handles) end, 100)
end
fidget_99()

-- Show opencode progress in fidget.nvim
local fidget_handle = nil

vim.api.nvim_create_autocmd("User", {
	pattern = "OpencodeEvent:*",
	callback = function(args)
		local event = args.data.event
		local props = event.properties or {}

		local is_busy = false
		if event.type == "session.status" and props.status then is_busy = props.status.type == "busy" end

		local is_idle = event.type == "session.idle"
			or (event.type == "session.sitatus" and props.status and props.status.type == "idle")

		if is_busy and not fidget_handle then
			fidget_handle = require("fidget.progress").handle.create({
				title = "",
				message = "",
				lsp_client = { name = "opencode" },
			})
		elseif is_idle and fidget_handle then
			fidget_handle:finish()
			fidget_handle = nil
		end
	end,
})
