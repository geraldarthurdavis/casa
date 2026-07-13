--[[
Behaviors:
- Declares the full Packer plugin set for this Neovim config across theme, UI, navigation, LSP, completion, git, AI, file tree, and language-specific tooling.
- Prefers a local Avante checkout at `~/Developer/engi/engi.nvim` when present and otherwise falls back to the remote plugin.
- Includes plugin-local setup hooks, build steps, and lazy-loading triggers such as filetypes and user commands.
]]
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Packer can manage itself
  -- system
  use 'neovim/nvim-lspconfig'
  -- style
  use 'Soares/base16.nvim'
  use 'famiu/nvim-reload'          -- easy reloading  after editing vim configuration
  use "b0o/mapx.nvim"              -- easier mapping settings
  use "edluffy/hologram.nvim"      -- image previewing
  use 'sainnhe/edge'               -- edge dark theme
  use 'drybalka/tree-climber.nvim' -- navigate around highlighting
  use 'lewis6991/spellsitter.nvim' -- spell checker
  use 'andymass/vim-matchup'       -- block/bracket-wise movement
  use "svermeulen/vim-cutlass"     -- override vim's default cut (`dd` in Normal, etc.) behavior
  use "svermeulen/vim-subversive"  -- substitues with text objects
  use "windwp/nvim-autopairs"      -- open/closing brackets, parentheses, braces etc.
  use { 'romgrk/fzy-lua-native', run = 'make' }
  use "nathom/filetype.nvim"       -- faster startup
  use "triglav/vim-visual-increment"
  use { 'tpope/vim-dispatch', opt = true, cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'preservim/nerdcommenter'       -- commenting commenting
  use 'mfussenegger/nvim-dap'         -- debugger, breakpoints, step-through
  use 'simrat39/rust-tools.nvim'      -- Rust debugging
  use 'edluffy/specs.nvim'            -- animate cursor when moving
  use 'kyazdani42/nvim-web-devicons'  -- nicer icons for file trees, diagnostic lists, etc.
  use 'junegunn/goyo.vim'             -- writing in vim
  use 'bfredl/nvim-ipy'
  use 'simrat39/symbols-outline.nvim' -- symbol viewer
  use 'mhinz/vim-startify'            -- cool vim startup screen
  -- use 'yaegassy/coc-tailwindcss3' -- tailwind completion and rule preview
  use 'tomlion/vim-solidity'
  use 'nvim-lua/plenary.nvim'
  use 'MunifTanjim/nui.nvim'
  use 'HakonHarnes/img-clip.nvim'
  use 'MeanderingProgrammer/render-markdown.nvim'
  use 'stevearc/dressing.nvim' -- for enhanced input UI
  use 'folke/snacks.nvim'      -- for modern input UI
  use 'yetone/avante.nvim'

  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' } -- preview markdown files in a browser page

  -- run our vim in the browser
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  use 'folke/trouble.nvim' -- show diagnostics (pretty 💅)

  -- add git to buffer, statusline, etc.
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end
  }

  use 'tjdevries/colorbuddy.vim'

  -- kitty navigation integration
  use { 'knubie/vim-kitty-navigator', run = 'cp ./../../kitty/*.py ~/.config/kitty/' }

  -- file tree
  use 'kyazdani42/nvim-tree.lua'

  use {
    "antosha417/nvim-lsp-file-operations",
    requires = {
      "nvim-lua/plenary.nvim",
      --"nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  }

  use 'romgrk/barbar.nvim' -- a great buffer tab bar

  -- status line
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require 'lualine'.setup {
        options = {
          theme = 'edge'
        },
      }
    end
  }

  -- syntax highlighting, refactoring
  use 'nvim-treesitter/nvim-treesitter'

  -- searching
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } -- faster searching

  use "SmiteshP/nvim-navic"                                        -- show language specific context in status line
  use {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup(require('winbar'))
    end,
  } -- sticky syntax context at top of window

  -- ╭──────────────────────────────────────────────────────────────╮
  -- │  LSP and external tooling installer (Mason)                 │
  -- ╰──────────────────────────────────────────────────────────────╯
  use {
    'williamboman/mason.nvim'
  }
  use {
    'williamboman/mason-lspconfig.nvim',
    requires = { 'neovim/nvim-lspconfig' }
  }

  -- autocomplete
  use({
    "hrsh7th/nvim-cmp", -- use for automcompletion engine
    requires = {
      {
        "KadoBOT/cmp-plugins",
        config = function()
          require("cmp-plugins").setup({
            files = { ".*\\.lua" } -- default
          })
        end,
      },
    }
  })
  use "hrsh7th/cmp-nvim-lsp"                                              -- use to provide the LSP source to autocomplete (cmp)
  use "hrsh7th/cmp-path"                                                  -- use to autocomplete file & directory paths
  use "hrsh7th/cmp-calc"                                                  -- use to evaluate/autocomplete mathematical expressions
  use { 'tzachar/cmp-fuzzy-buffer', requires = { 'tzachar/fuzzy.nvim' } } -- use for better fuzzy buffer autocompletion
  -- use to add snippets source to autocomplete via LuaSnip
  use {
    "saadparwaiz1/cmp_luasnip",
    requires = {
      {
        "L3MON4D3/LuaSnip",
        run = "make install_jsregexp",
      },
    },
  }
  -- use to add more snippets to LuaSnip
  use { "rafamadriz/friendly-snippets" }
  -- git commit completion
  use 'petertriho/cmp-git'
  use {
    'sindrets/diffview.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewFileHistory',
      'DiffviewRefresh',
    },
    config = function()
      require('git').setup_diffview()
    end,
  }
  use 'hrsh7th/cmp-nvim-lsp-signature-help' -- use to automcomplete better function signatures

  -- use to add Rust/Cargo crates source to autocomplet
  use {
    'saecki/crates.nvim',
    config = function()
      require('crates').setup()
    end,
  }

  use {
    'David-Kunz/cmp-npm',
    config = function()
      require('cmp-npm').setup()
    end,
  }

  -- TODOs
  --use {
  --"zbirenbaum/copilot.lua",
  --requires = {
  --"copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  --},
  --cmd = "Copilot",
  --event = "InsertEnter",
  --config = function()
  --require("copilot").setup({})
  --end,
  --}

  --local local_avante_path = vim.fn.expand("~/Developer/avante.nvim/")
  --local has_local_avante = vim.fn.isdirectory(local_avante_path) == 1
  --
  -- use 'JoosepAlviste/nvim-ts-context-commentstring' -- improve commenting in multi-langugage files (CSS-in-JS). is this working?

  -- TODO: linting with ale?
  --use {
  --'w0rp/ale',
  --ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
  --cmd = 'ALEEnable',
  --config = 'vim.cmd[[ALEEnable]]'
  --}

  -- TODO: hererocks breaking when uncommented
  --use_rocks 'penlight'                                                                            -- helpful Lua functions for common programming patterns
  --use_rocks 'lua-resty-http'                                                                      -- Lua http helpers
  --use_rocks 'lpeg'                                                                                -- Lua regex helpers
  --
  --use { 'sourcegraph/sg.nvim', run = 'nvim -l build/init.lua' }
end)
