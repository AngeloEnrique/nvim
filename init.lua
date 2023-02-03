require('base')
require('highlights')
require('maps')
require('initPlugins')
require('colorscheme')
require('winbar')
require('copilot')
local has = function(x)
  return vim.fn.has(x) == 1
end

local is_mac = has "macunix"
local is_win = has "win32"

if is_mac then
  require('macos')
end
if is_win then
  require('windows')
end
