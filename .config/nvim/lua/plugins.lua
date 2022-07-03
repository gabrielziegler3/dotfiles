return require('packer').startup(function()
  use { "wbthomason/packer.nvim" }
  use { "neovim/nvim-lspconfig" }
  use { "ray-x/lsp_signature.nvim" }
  use { "hrsh7th/nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lsp" } -- LSP source for nvim-cmp
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { "saadparwaiz1/cmp_luasnip" } -- Snippets source for nvim-cmp
  use { "L3MON4D3/LuaSnip" } -- Snippets plugin
  use { "ayu-theme/ayu-vim" } -- Colorscheme
  use {
    "TimUntersberger/neogit", -- Git
    requires = "nvim-lua/plenary.nvim",
  }
  use {
      'nvim-telescope/telescope.nvim', -- Fuzzy finder
      requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
end)

