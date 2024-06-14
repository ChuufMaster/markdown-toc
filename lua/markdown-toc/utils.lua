local config = require('markdown-toc.config')
local select_heading_level = require('markdown-toc.select_heading_level')
local pick_git_file = require('markdown-toc.pick_paths').pick_git_file
local get_relative_path = require('markdown-toc.pick_paths').get_relative_path
local delete_TOC = require('markdown-toc.delete_TOC').delete_TOC
local M = {}

function M.read_file(filepath)
  local file = io.open(filepath, 'r')
  if not file then
    return nil
  end

  local content = file:read('*all')
  file:close()
  return content
end

function M.process_heading(content, filepath, heading_level_to_match)
  local lines = {}
  for line in content:gmatch('[^\r\n]+') do
    table.insert(lines, line)
  end

  local output = {}

  local current_buffer = vim.api.nvim_buf_get_name(0)
  local relative_path = get_relative_path(current_buffer, filepath)

  for _, line in ipairs(lines) do
    local heading_level, heading_text = line:match('^(#+)%s*(.+)')
    if heading_level and heading_text then
      local level = #heading_level - 1
      local tabs = string.rep('\t', level)
      local heading_anchor = heading_text:gsub('%s+', '-')
      heading_anchor = heading_anchor:lower()

      --[[ 
      --  This little block of code gave a lot of probles but for anyone interested
      --  the reason why you have to add '%EF%B8%8F' for cases where the string has 
      --  the unicode character U+FE0F is because of unicode variations which take up two
      --  character spaces compared to the usual one. You need to do this becacuase it
      --  some emojis are built on top of "plain text" emojis, like the heart which
      --  can be rendered as either a red heart ❤️ which is the VS16 variation or it can
      --  be rendered as normal character ❤ which is the VS15 selector. 
      --
      --  For some reason on GitHub if the emojis has a VS16 selector then the
      --  heading anchor needs to have '%EF%B8%8F' wherever the emojis appears
      --
      --  If you ever want to see how this works and that the emojis do actually
      --  take up two charcters go into github and edit a file on github that
      --  has an emoji with a VS16 variation and when you use backspace it will
      --  first become the VS15 variation before you then need to hit backspace
      --  to delete the emoji
      --]]

      if heading_anchor:find('[\u{FE0F}]') then
        heading_anchor =
          heading_anchor:gsub('[\u{1F600}-\u{1F64F}]', '%EF%B8%8F')
      else
        heading_anchor = heading_anchor:gsub('[\u{1F600}-\u{1F64F}]', '')
      end
      local formatted_line = string.format(
        config.options.toc_format,
        tabs,
        heading_text,
        relative_path,
        heading_anchor
      )
      if
        heading_level_to_match == -1
        or #heading_level <= heading_level_to_match
      then
        table.insert(output, formatted_line)
      end
    end
  end

  local toc = table.concat(output, '\n')

  delete_TOC()

  local current_buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  vim.api.nvim_buf_set_lines(
    current_buf,
    row - 1,
    row - 1,
    false,
    vim.split(toc, '\n')
  )
end

function M.generate_toc_from_file(filepath, heading_level_to_match)
  local content = M.read_file(filepath)

  if not content then
    print('failed to read the file.')
    return
  end

  if heading_level_to_match then
    M.process_heading(content, filepath, heading_level_to_match)
    return
  end

  heading_level_to_match = config.options.heading_level_to_match
  if config.options.ask_for_heading_level then
    select_heading_level(function(heading_level)
      M.process_heading(content, filepath, heading_level)
    end)
  else
    M.process_heading(content, filepath, heading_level_to_match)
  end
end

function M.pick_file_with_telescope(args)
  pick_git_file(function(filepath)
    args = args or nil
    local heading_level
    if args ~= nil then
      heading_level = tonumber(args)
    end

    M.generate_toc_from_file(filepath, heading_level)
  end)
end

function M.load()
  vim.api.nvim_create_user_command('GenerateTOC', function(opts)
    M.pick_file_with_telescope(opts.args)
  end, { nargs = '?' })

  vim.api.nvim_create_user_command('DeleteTOC', function()
    delete_TOC()
  end, {})
end

return M
