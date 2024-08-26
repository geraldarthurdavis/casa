require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "markdown", "lua", "python", "rust", "javascript", "typescript", "tsx", "json", "css", "c", "cpp", "bash", "dockerfile", "go", "graphql", "markdown_inline", "toml" }, -- Add other languages as needed
  highlight = {
    enable = true,                                                                                                                                                                            -- false will disable the whole extension
    additional_vim_regex_highlighting = false,                                                                                                                                                -- ?
  },
}
