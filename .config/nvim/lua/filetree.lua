-- file tree
--
-- @see https://github.com/nvim-tree/nvim-tree.lua

local nvim_tree = require('nvim-tree')
local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

map('n', '<leader>ff', ':NvimTreeFindFile<cr>', options)
map('n', '<leader>fo', ':NvimTreeOpen<cr>', options)
map('n', '<leader>fc', ':NvimTreeClose<cr>', options)

-- FIX: open filetree when opening vim for the first time


-- TODO: close the filetree when exiting last vim buffer
-- only remaining buffers after closing a file are diagnostics and file tree, quit vim
--vim.api.nvim_command([[
--augroup CloseFileTreeWhenLeavingVim
--autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
--augroup END
--]])
--

nvim_tree.setup({
  view = {
    side = "right"
  },

  renderer = {
    highlight_git = true,

    icons = {
      show = {
        folder_arrow = false,
        git = true,
      }
    }
  }
})
