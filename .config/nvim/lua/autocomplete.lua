-- autocomplete.lua
--
-- autocomplete uses nvim-cmp, nvim-lspconfig, snippets, and more to create a configurable and robust
-- completion solution

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

local cmp = require('cmp') -- completion plugin
local luasnip = require('luasnip') -- how to expand snippet (completion)

local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  -- provide luasnip as expansion mechanism
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },

  -- ordered by priority data sources for completion menu
  sources = {
    {name = 'path'}, -- complete the filepath
    {name = 'nvim_lsp', keyword_length = 3}, -- complete from language server
    {name = 'buffer', keyword_length = 3}, -- complete with other words in buffer
    {name = 'luasnip', keyword_length = 2}, -- ?
    -- friendly snippets, copilot?
  },

  -- style completion UI
  window = {
    documentation = cmp.config.window.bordered()
  },

  -- format  completion items
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = '', --  LSP code completion
        luasnip = '⋗',
        buffer = '', -- words in buffer
        path = '', -- filepath
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,

  },

  -- maps & motion
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  }
})

