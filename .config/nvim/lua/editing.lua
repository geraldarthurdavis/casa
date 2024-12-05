local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

-- write 'kuick'
map('i', '<leader>kw', '<esc>:w<cr>', options)
map('n', '<leader>kw', ':w<cr>', options)
-- jump (out of insert) 'kuick'
map('i', '<leader>kj', '<esc>', options)

-- replace
-- substitues with text objects
map('n', 's', '<Cmd>:SubversiveSubstitute<CR>', options)
map('n', 'ss', '<Cmd>:SubversiveSubstituteLine<CR>', options)
map('n', 'S', '<Cmd>:SubversiveSubstituteToEndOfLine<CR>', options)
