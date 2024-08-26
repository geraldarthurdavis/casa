local opt = vim.opt
local navic = require("nvim-navic")

require("lualine").setup({
  sections = {
    -- add a section in the middle of the statusline that shows the current code location
    lualine_c = {
      { navic.get_location, cond = navic.is_available },
    }
  }
})

-- views can only be fully collapsed with the global statusline
opt.laststatus = 3
