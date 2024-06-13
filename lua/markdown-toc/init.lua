local utils = require('markdown-toc.utils')

local M = {}

M.utils = utils

function M.setup()
  utils.load()
end

M.setup()

return M
