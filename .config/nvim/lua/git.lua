-- git + vim 💕

local cmp = require('cmp') -- completion plugin

-- set autocomplete for git commits
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

if vim.fn.has('nvim') then
  vim.env.GIT_EDITOR = 'nvr -cc split --remote-wait' 
end
