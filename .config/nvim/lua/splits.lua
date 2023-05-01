-- splits

local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }
local opt = vim.opt

opt.splitbelow = true
opt.splitright = true

map('n', '<leader>hs', '<CMD>:split<CR>', options)
map('n', '<leader>vs', '<CMD>:vsplit<CR>', options)

map('n', '<C-D-h>', '<C-W><C-H>', options)
map('n', '<C-D-j>', '<C-W><C-J>', options)
map('n', '<C-D-k>', '<C-W><C-K>', options)
map('n', '<C-D-l>', '<C-W><C-L>', options)
