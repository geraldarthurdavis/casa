local navic = require("nvim-navic")

require("lualine").setup({
  sections = {
    -- add a section in the middle of the statusline that shows the current code location
    lualine_c = {
      { navic.get_location, cond = navic.is_available },
    }
  }
})
