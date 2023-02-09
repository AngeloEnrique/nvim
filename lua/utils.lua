local M = {}
local uv = vim.loop

-- recursive Print (structure, limit, separator)
-- local function r_inspect_settings(structure, limit, separator)
--   limit = limit or 100 -- default item limit
--   separator = separator or "." -- indent string
--   if limit < 1 then
--     print "ERROR: Item limit reached."
--     return limit - 1
--   end
--   if structure == nil then
--     io.write("-- O", separator:sub(2), " = nil\n")
--     return limit - 1
--   end
--   local ts = type(structure)
--
--   if ts == "table" then
--     for k, v in pairs(structure) do
--       -- replace non alpha keys with ["key"]
--       if tostring(k):match "[^%a_]" then
--         k = '["' .. tostring(k) .. '"]'
--       end
--       limit = r_inspect_settings(v, limit, separator .. "." .. tostring(k))
--       if limit < 0 then
--         break
--       end
--     end
--     return limit
--   end
--
--   if ts == "string" then
--     -- escape sequences
--     structure = string.format("%q", structure)
--   end
--   separator = separator:gsub("%.%[", "%[")
--   if type(structure) == "function" then
--     -- don't print functions
--     io.write("-- lvim", separator:sub(2), " = function ()\n")
--   else
--     io.write("lvim", separator:sub(2), " = ", tostring(structure), "\n")
--   end
--   return limit - 1
-- end

-- function M.generate_settings()
--   -- Opens a file in append mode
--   local file = io.open("lv-settings.lua", "w")
--
--   -- sets the default output file as test.lua
--   io.output(file)
--
--   -- write all `lvim` related settings to `lv-settings.lua` file
--   r_inspect_settings(lvim, 10000, ".")
--
--   -- closes the open file
--   io.close(file)
-- end

--- Returns a table with the default values that are missing.
--- either parameter can be empty.
--@param config (table) table containing entries that take priority over defaults
--@param default_config (table) table contatining default values if found
function M.apply_defaults(config, default_config)
	config = config or {}
	default_config = default_config or {}
	local new_config = vim.tbl_deep_extend("keep", vim.empty_dict(), config)
	new_config = vim.tbl_deep_extend("keep", new_config, default_config)
	return new_config
end

--- Checks whether a given path exists and is a file.
--@param path (string) path to check
--@returns (bool)
function M.is_file(path)
	local stat = uv.fs_stat(path)
	return stat and stat.type == "file" or false
end

--- Checks whether a given path exists and is a directory
--@param path (string) path to check
--@returns (bool)
function M.is_directory(path)
	local stat = uv.fs_stat(path)
	return stat and stat.type == "directory" or false
end

---Write data to a file
---@param path string can be full or relative to `cwd`
---@param txt string|table text to be written, uses `vim.inspect` internally for tables
---@param flag string used to determine access mode, common flags: "w" for `overwrite` or "a" for `append`
function M.write_file(path, txt, flag)
	local data = type(txt) == "string" and txt or vim.inspect(txt)
	uv.fs_open(path, flag, 438, function(open_err, fd)
		assert(not open_err, open_err)
		uv.fs_write(fd, data, -1, function(write_err)
			assert(not write_err, write_err)
			uv.fs_close(fd, function(close_err)
				assert(not close_err, close_err)
			end)
		end)
	end)
end

function M.buf_kill(kill_command, bufnr, force)
	kill_command = kill_command or "bd"

	local bo = vim.bo
	local api = vim.api
	local fmt = string.format
	local fnamemodify = vim.fn.fnamemodify

	if bufnr == 0 or bufnr == nil then
		bufnr = api.nvim_get_current_buf()
	end

	local bufname = api.nvim_buf_get_name(bufnr)

	if not force then
		local warning
		if bo[bufnr].modified then
			warning = fmt([[No write since last change for (%s)]], fnamemodify(bufname, ":t"))
		elseif api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
			warning = fmt([[Terminal %s will be killed]], bufname)
		end
		if warning then
			vim.ui.input({
				prompt = string.format([[%s. Close it anyway? [y]es or [n]o (default: no): ]], warning),
			}, function(choice)
				if choice:match("ye?s?") then
					force = true
				end
			end)
			if not force then
				return
			end
		end
	end

	-- Get list of windows IDs with the buffer to close
	local windows = vim.tbl_filter(function(win)
		return api.nvim_win_get_buf(win) == bufnr
	end, api.nvim_list_wins())

	if #windows == 0 then
		return
	end

	if force then
		kill_command = kill_command .. "!"
	end

	-- Get list of active buffers
	local buffers = vim.tbl_filter(function(buf)
		return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
	end, api.nvim_list_bufs())

	-- If there is only one buffer (which has to be the current one), vim will
	-- create a new buffer on :bd.
	-- For more than one buffer, pick the previous buffer (wrapping around if necessary)
	if #buffers > 1 then
		for i, v in ipairs(buffers) do
			if v == bufnr then
				local prev_buf_idx = i == 1 and (#buffers - 1) or (i - 1)
				local prev_buffer = buffers[prev_buf_idx]
				for _, win in ipairs(windows) do
					api.nvim_win_set_buf(win, prev_buffer)
				end
			end
		end
	end

	-- Check if buffer still exists, to ensure the target buffer wasn't killed
	-- due to options like bufhidden=wipe.
	if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
		vim.cmd(string.format("%s %d", kill_command, bufnr))
	end
end

return M
