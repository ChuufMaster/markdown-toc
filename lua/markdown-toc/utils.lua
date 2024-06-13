local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local M = {}

function M.read_file(filepath)
  print('read_file')
  local file = io.open(filepath, 'r')
  if not file then
    return nil
  end

  local content = file:read('*all')
  file:close()
  return content
end

function M.process_heading(content, filepath)
  print('process_heading')
  local lines = {}
  for line in content:gmatch('[^\r\n]+') do
    table.insert(lines, line)
  end

  local output = {}
  local filename = filepath:match('^.+/(.+)$')
  local basename = filename:match('(.+)%..+$')

  local heading_level_to_match = -1
  for _, line in ipairs(lines) do
    local heading_match = '#+'
    if heading_level_to_match ~= -1 then
      heading_match = ''
      for _ = 1, heading_level_to_match do
        heading_match = heading_match .. '#'
      end
    end

    local heading_level, heading_text =
      line:match('^(' .. heading_match .. ')%s*(.+)')
    if heading_level and heading_text then
      local level = #heading_level - 1
      local tabs = string.rep('\t', level)
      local heading_anchor = heading_text:gsub('%s+', '-')
      heading_anchor = heading_anchor:lower()
      local formatted_line = string.format(
        '%s- [%s](<%s#%s>)',
        tabs,
        heading_text,
        filename,
        heading_anchor
      )
      table.insert(output, formatted_line)
    end
  end

  return table.concat(output, '\n')
end

function M.generate_toc_from_file(filepath)
  print('generate_toc_from_file')
  local content = M.read_file(filepath)

  if not content then
    print('failed to read the file.')
    return
  end

  local toc = M.process_heading(content, filepath)

  local current_buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(current_buf, row, row, false, vim.split(toc, '\n'))
end

function M.pick_file_with_telescope()
  print('pick_file_with_telescope')
  builtin.find_files({
    prompt_title = 'Select Markwon File',
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        M.generate_toc_from_file(selection.path)
      end)
      return true
    end,
  })
end

function M.load()
  vim.api.nvim_create_user_command('GenerateTOC', function()
    M.pick_file_with_telescope()
  end, {})
end

return M
