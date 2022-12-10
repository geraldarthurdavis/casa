-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Simple plugins can be specified as strings
  use 'rstacruz/vim-closer'
  use 'Soares/base16.nvim'
  -- easy reloading  after editing vim configuration
  use 'famiu/nvim-reload'
  -- easier mapping settings
  use "b0o/mapx.nvim"
  -- image previewing
  use "edluffy/hologram.nvim"
  -- edge dark theme
  use 'sainnhe/edge'
  -- show context
  use 'lewis6991/nvim-treesitter-context'
  -- highlight definitions and usages
  use 'nvim-treesitter/nvim-treesitter-refactor'
  -- navigate around highlighting
  use 'drybalka/tree-climber.nvim'
  -- spell checker
  use 'lewis6991/spellsitter.nvim'
  -- commenting
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  -- insert matching pair of quotes, brackets, etc.
  use 'andymass/vim-matchup'
  -- show registers
  use "tversteeg/registers.nvim"
  -- override vim's default cut (`dd` in Normal, etc.) behavior
  use "svermeulen/vim-cutlass"
  -- substitues with text objects
  use "svermeulen/vim-subversive"
  -- easy motion (vimium style navigation)
  use {
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- Lazy loading:
  -- Load on specific commands
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'

  -- Load on a combination of conditions: specific filetypes or commands
  -- Also run code after load (see the "config" key)
  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    cmd = 'ALEEnable',
    config = 'vim.cmd[[ALEEnable]]'
  }

  -- Plugins can have dependencies on other plugins
  use {
    'haorenW1025/completion-nvim',
    opt = true,
    requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
  }

  -- You can specify rocks in isolation
  use_rocks 'penlight'
  use_rocks {'lua-resty-http', 'lpeg'}

  -- Plugins can have post-install/update hooks
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

  -- Post-install/update hook with call of vimscript function with argument
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  -- Use dependency and run lua function after load
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }

  -- You can specify multiple plugins in a single call
  use {'tjdevries/colorbuddy.vim'}

  -- kitty navigation integration
  use { 'knubie/vim-kitty-navigator' }

  -- file tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require'nvim-tree'.setup {
      view = {
        side = "right"
      },
      renderer = {
        icons = {
          show = {
            folder_arrow = false
          }
        }
      }
    } end
  }

  -- copy & paste

  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require'lualine'.setup {
      options = {
        theme = 'edge'
      },
    } end
  }

  -- syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require'nvim-treesitter'.setup {
      ensure_installed = "all",

      hightlight = {
        enable = true
      },

      indent = {
        enable = true
      },

      rainbow = {
        enable = true,
        extended_mode = true, -- html tags
        max_file_lines = nil
     },

     context_commentstring = {
        enable = true
     }
    } end
  }

  -- file search
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- copilot
  use 'github/copilot.vim'

  -- language servers for syntax, autocomplete, status line, etc.
  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig'
  }

  -- show language specific context in status line
  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  }

  -- autocomplete
  use { "hrsh7th/nvim-cmp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { "saadparwaiz1/cmp_luasnip" }
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "L3MON4D3/LuaSnip" } -- handling text completion insert when completion data is provided
  use { "rafamadriz/friendly-snippets" }

end)
