-- file tree
--
-- @see https://github.com/nvim-tree/nvim-tree.lua

local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

map('n', '<leader>of', ':NvimTreeFindFile<cr>', options)
map('n', '<leader>oft', ':NvimTreeOpen<cr>', options)
map('n', '<leader>cf', ':NvimTreeClose<cr>', options)


-- TODO: close the filetree when exiting last vim buffer
-- only remaining buffers after closing a file are diagnostics and file tree, quit vim
--vim.api.nvim_command([[
  --augroup CloseFileTreeWhenLeavingVim
    --autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  --augroup END
--]])

