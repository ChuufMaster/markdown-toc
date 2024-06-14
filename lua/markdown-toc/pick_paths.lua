local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local M = {}

function M.get_relative_path(file1, file2)
  local common_prefix = ''
  local i = 1

  while i <= #file1 and i <= #file2 and file1:sub(i, i) == file2:sub(i, i) do
    common_prefix = common_prefix .. file1:sub(i, i)
    i = i + 1
  end

  local relative_path = ''
  if i <= #file1 then
    local remaining_path = file1:sub(i)
    local num_dirs_up = select(2, remaining_path:gsub('/', ''))
    relative_path = ('../'):rep(num_dirs_up) .. file2:sub(i)
  else
    relative_path = file2:sub(i)
  end

  return relative_path
end

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
