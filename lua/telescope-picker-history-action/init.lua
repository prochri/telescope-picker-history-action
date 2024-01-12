local ok, _ = pcall(require, "telescope")
if not ok then
	vim.notify("telescope-picker-history-action: Telescope is not installed", vim.log.levels.ERROR)
	return
end

local state = require("telescope.state")
local builtin = require("telescope.builtin")

local current_history_index = nil
local in_telescope_history = false
local augroup = "telescope-picker-history-action"

local function setup()
	vim.api.nvim_create_augroup(augroup, {})
	vim.api.nvim_create_autocmd("WinLeave", {
		group = augroup,
		callback = function()
			if vim.bo.filetype ~= "TelescopePrompt" then
				return
			end
			if not in_telescope_history then
				current_history_index = nil
			end
			in_telescope_history = false
		end,
	})
end

local function resume_picker(i)
	in_telescope_history = true
	builtin.resume({ cache_index = i })
end

local function picker_history(prev)
	local cached_pickers = state.get_global_key("cached_pickers")
	if not cached_pickers then
		vim.notify("There is no picker history", vim.log.levels.WARN)
		return
	end
	local cached_picker_copy = {}
	for k, v in pairs(cached_pickers) do
		cached_picker_copy[k] = v
	end
	if not current_history_index then
		if prev then
			current_history_index = 2
			resume_picker(1)
		end
		return
	end

	local i = current_history_index + (prev and 1 or -1)
	if i < 1 or i > #cached_pickers then
		if prev then
			vim.notify("No previous picker in history at index " .. i, vim.log.levels.WARN)
		else
			vim.notify("No next picker in history at index " .. i, vim.log.levels.WARN)
		end
		return
	end
	current_history_index = i
	resume_picker(i)
	state.set_global_key("cached_pickers", cached_picker_copy)
end

return {
	next_picker = function()
		picker_history(false)
	end,
	prev_picker = function()
		picker_history(true)
	end,
	setup = setup,
}
