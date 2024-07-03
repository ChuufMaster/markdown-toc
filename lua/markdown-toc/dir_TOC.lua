local get_relative_path =
  require('markdown-toc.relative_path').get_relative_path

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local entry_display = require('telescope.pickers.entry_display')

local M = {}

local selected_files = {}

function M.add_file_to_list(prompt_bufnr)
  local selected_entry = action_state.get_selected_entry()
  local filepath = selected_entry.path or selected_entry.file_name
  table.insert(selected_files, filepath)
  actions.close(prompt_bufnr)
end

function M.custom_picker(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'Select Files',
      finder = finders.find_files(),
      sorter = sorters.get_generic_fuzzy_sorter(),
      attach_mappings = function(_, map)
        map('i', '<CR>', M.add_file_to_list)
        map('n', '<CR>', M.add_file_to_list)
        return true
      end,
    })
    :find()
end

return M
