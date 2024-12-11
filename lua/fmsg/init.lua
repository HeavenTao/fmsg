local _M = {}

_M.setup = function() end

_M.showMsg = function()
	local msg = _M.getMessage()
	_M.showFloatWin(msg)
end

_M.close = function(buf, win) end

_M.showFloatWin = function(msg)
	local buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, msg)

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>q<cr>", {})

	local width = vim.api.nvim_get_option_value("columns", {})
	local height = vim.api.nvim_get_option_value("lines", {})

	local win_width = math.ceil(width * 0.8)
	local win_height = math.ceil(height * 0.7)

	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)

	local opts = {
		relative = "editor",
		style = "minimal",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
		noremap = true,
		silent = true,
		callback = function()
			vim.api.nvim_win_close(win, true)
		end,
	})
end

_M.getMessage = function()
	local msg = vim.api.nvim_cmd({ cmd = "message" }, { output = true })
	local lines = vim.split(msg, "\n")
	return lines
end

return _M
