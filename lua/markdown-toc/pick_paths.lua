local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

function M.pick_git_file(callback)
  local git_dir = vim.fn.finddir('.git', vim.fn.getcwd() .. ';')
  -- print(git_dir ~= '')
  if git_dir == '' then
    builtin.find_files({
      prompt_title = 'Select a file from CWD',
      search_file = '*.md',
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          callback(selection.path)
        end)
        return true
      end,
    })
    return
  end
  builtin.git_files({
    prompt_title = 'Select a file from your Git repository',
    use_git_root = false,
    git_command = {
      'git',
      'ls-files',
      '--exclude-standard',
      '--cached',
      '*.md',
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        callback(selection.path)
        -- Do something with the relative path if needed
      end)
      return true
    end,
  })
end

return M
