local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

vim.g.kitty_navigator_no_mappings = 1

-- terminal (kitty) + neovim navigation
map('n', '<C-k>', ':KittyNavigateUp<cr>', options)
map('n', '<C-l>', ':KittyNavigateRight<cr>', options)
map('n', '<C-j>', ':KittyNavigateDown<cr>', options)
map('n', '<C-h>', ':KittyNavigateLeft<cr>', options)
