---@class Config

local M = {}

local defaults = {

  -- The heading level to match (i.e the number of "#"s to match to)
  heading_level_to_match = -1,

  -- Set to display a dropdown to allow you to select the heading level
  ask_for_heading_level = false,

  -- TOC default string
  -- The first %s is for indenting/tabs
  -- The sencond %s is for the original headings text
  -- The third %s is for the markdown files path that the TOC is being generated
  -- from
  -- The forth %s is for the target heading using the markdown rules
  toc_format = '%s- [%s](<%s#%s>)',
}

---@type Config
M.options = {}

---@param options Config|nil
function M.setup(options)
  M.options = vim.tbl_deep_extend('force', {}, defaults, options or {})
  if M.options.heading_level_to_match > 6 then
    M.options.heading_level_to_match = 6
  end
end

---@param options Config|nil
function M.extend(options)
  M.options =
    vim.tbl_deep_extend('force', {}, M.options or defaults, options or {})
end

return M
