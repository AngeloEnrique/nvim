local status, comment = pcall(require, 'Comment')
if (not status) then return end
local pre_hook
local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
if loaded and ts_comment then
  pre_hook = ts_comment.create_pre_hook()
end

comment.setup {
  pre_hook = pre_hook,
}
