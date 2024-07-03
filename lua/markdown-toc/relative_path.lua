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

return M
