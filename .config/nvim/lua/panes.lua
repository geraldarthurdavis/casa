local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

vim.g.kitty_navigator_no_mappings = 1
vim.g.tmux_navigator_no_mappings = 1

-- terminal (kitty) + neovim navigation
map('n', '<C-k>', ':KittyNavigateUp <cr>', options)
map('n', '<C-l>', ':KittyNavigateRight <cr>', options)
map('n', '<C-j>', ':KittyNavigateDown <cr>', options)
map('n', '<C-h>', ':KittyNavigateLeft <cr>', options)

-- Kitty (maybe needed when using lazy vim?)
--if os.getenv("TERM") == "xterm-kitty" then
--vim.g.kitty_navigator_no_mappings = 1
--vim.g.tmux_navigator_no_mappings = 1

--vim.cmd([[
--noremap <silent> <c-h> :<C-U>KittyNavigateLeft<cr>
--noremap <silent> <c-l> :<C-U>KittyNavigateRight<cr>
--noremap <silent> <c-j> :<C-U>KittyNavigateDown<cr>
--noremap <silent> <c-k> :<C-U>KittyNavigateUp<cr>
--]])
--end
