-- Smart navigation functions
local function smart_navigate(direction)
  local current_win = vim.api.nvim_get_current_win()
  local current_pos = vim.api.nvim_win_get_cursor(current_win)

  -- Try to move to another window
  vim.cmd('wincmd ' .. direction)

  -- If we didn't move (same window and cursor position), send the key through
  if current_win == vim.api.nvim_get_current_win() and
      vim.deep_equal(current_pos, vim.api.nvim_win_get_cursor(current_win)) then
    local key = vim.api.nvim_replace_termcodes('<C-\\><C-N>', true, true, true)
    vim.api.nvim_feedkeys(key, 'n', false)
    -- Send the original keystroke through
    local ctrl_key = vim.api.nvim_replace_termcodes('<C-' .. direction .. '>', true, true, true)
    vim.api.nvim_feedkeys(ctrl_key, 'n', false)
  end
end

-- Set up the mappings
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Smart window navigation
map('n', '<C-h>', function() smart_navigate('h') end, opts)
map('n', '<C-j>', function() smart_navigate('j') end, opts)
map('n', '<C-k>', function() smart_navigate('k') end, opts)
map('n', '<C-l>', function() smart_navigate('l') end, opts)

-- Also work in terminal mode
map('t', '<C-h>', function() smart_navigate('h') end, opts)
map('t', '<C-j>', function() smart_navigate('j') end, opts)
map('t', '<C-k>', function() smart_navigate('k') end, opts)
map('t', '<C-l>', function() smart_navigate('l') end, opts)
