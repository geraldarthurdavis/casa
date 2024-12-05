local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

map('n', '<leader>ch', ':nohlsearch<cr>', options)

-- Toggle folds
map('n', 'zz', 'za', options) -- Toggle current fold
map('n', 'zo', 'zR', options) -- Open all folds
map('n', 'zc', 'zM', options) -- Close all folds

-- Navigate between folds
map('n', 'zj', 'zjzz', options) -- Move to next fold and center screen
map('n', 'zk', 'zkzz', options) -- Move to previous fold and center screen

-- Adjust fold levels
map('n', '<leader>z+', ':lua for i=1,v:count1 do fold.increment() end<CR>', options)
map('n', '<leader>z-', ':lua for i=1,v:count1 do fold.decrement() end<CR>', options)

-- Helper functions for adjusting fold levels
local fold = {}

function fold.increment()
  local foldlevel = vim.wo.foldlevel
  vim.wo.foldlevel = foldlevel + 1
end

function fold.decrement()
  local foldlevel = vim.wo.foldlevel
  if foldlevel > 0 then
    vim.wo.foldlevel = foldlevel - 1
  end
end
