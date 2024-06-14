local utils = require('markdown-toc.utils')
local config = require('markdown-toc.config')

local M = {}

M.load = utils.load
M.setup = config.setup

M.load()

M.setup()

return M
