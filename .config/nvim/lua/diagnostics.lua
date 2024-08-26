-- type errors, linting
--
-- <leader>dn
--
-- @see https://github.com/folke/trouble.nvim

local trouble = require('trouble')
local options = {silent = true, noremap = true}

trouble.setup({
  use_diagnostic_signs = true
})

vim.keymap.set("n", "<leader>sd", "<cmd>TroubleToggle<cr>", options) -- show diagnostics
vim.keymap.set("n", "<leader>dd", "<cmd>TroubleToggle<cr>", options) -- show diagnostics
vim.keymap.set("n", "<leader>do", "<cmd>TroubleOpen<cr>", options) -- open diagnostics
vim.keymap.set("n", "<leader>dc", "<cmd>TroubleClose<cr>", options) -- close diagnostics

vim.keymap.set("n", "<leader>dnw", "<cmd>TroubleToggle workspace_diagnostics<cr>", options)
vim.keymap.set("n", "<leader>dnd", "<cmd>TroubleToggle document_diagnostics<cr>", options)
vim.keymap.set("n", "<leader>dnl", "<cmd>TroubleToggle loclist<cr>", options)
vim.keymap.set("n", "<leader>dnf", "<cmd>TroubleToggle quickfix<cr>", options)

-- TODO: remove default LSP references and use trouble?
-- TODO: use trouble for definitions too?
--vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  --{silent = true, noremap = true}
--)
