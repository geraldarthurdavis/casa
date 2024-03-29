vim.keymap.set("n", "<space>a", function()
  require("sg.cody.commands").toggle()
end)

vim.keymap.set("n", "<space>an", function()
  local name = vim.fn.input "chat name: "
  require("sg.cody.commands").chat(name)
end)

require("sg").setup {
  on_attach = require("lsp").on_attach,
  -- FIX: topleft vnew for cody split
}
