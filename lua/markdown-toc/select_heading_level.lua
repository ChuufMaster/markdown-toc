local conf = require('telescope.config').values
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function heading_level_picker(callback, opts)
  opts = opts or require('telescope.themes').get_dropdown({})

  local function select_number(prompt_bufnr)
    actions.select_default:replace(function()
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      callback(selection.value)
      -- print(vim.inspect(selection.value))
    end)
  end

  local pick_conf = {
    prompt_title = 'Select the level of headings to generate (-1 for all)',
    finder = finders.new_table({
      results = {
        { title = 'All', value = -1 },
        { title = 'One', value = 1 },
        { title = 'Two', value = 2 },
        { title = 'Three', value = 3 },
        { title = 'Four', value = 4 },
        { title = 'Five', value = 5 },
        { title = 'Six', value = 6 },
      },
      entry_maker = function(entry)
        return {
          display = entry.title,
          ordinal = entry.title .. entry.value,
          value = entry.value,
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      select_number(prompt_bufnr)
      return true
    end,
  }

  pickers.new(opts, pick_conf):find()
end

return heading_level_picker
