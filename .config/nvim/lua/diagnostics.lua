-- type errors, linting
--
-- <leader>dn
--
-- @see https://github.com/folke/trouble.nvim

local trouble = require('trouble')
local options = { silent = true, noremap = true }

trouble.setup({
  use_diagnostic_signs = true
})

vim.keymap.set("n", "<leader>dt", "<cmd>Trouble toggle<cr>", options)                -- toggle diagnostics
vim.keymap.set("n", "<leader>dd", "<cmd>Trouble document_diagnostics<cr>", options)  -- document diagnostics
vim.keymap.set("n", "<leader>dw", "<cmd>Trouble workspace_diagnostics<cr>", options) -- workspace diagnostics
vim.keymap.set("n", "<leader>dl", "<cmd>Trouble loclist<cr>", options)               -- location list
vim.keymap.set("n", "<leader>dq", "<cmd>Trouble quickfix<cr>", options)              -- quickfix list
vim.keymap.set("n", "<leader>dr", "<cmd>Trouble lsp_references<cr>", options)        -- LSP references

-- TODO: remove default LSP references and use trouble?
-- TODO: use trouble for definitions too?
--vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
--{silent = true, noremap = true}
--)
