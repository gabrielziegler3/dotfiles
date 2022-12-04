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
  use { "cseelus/vim-colors-lucid" } -- Colorscheme
  use { "github/copilot.vim" } -- Copilot
  use {
	'kyazdani42/nvim-tree.lua',
    	requires = {
      	'kyazdani42/nvim-web-devicons', -- optional, for file icons
	},
    	tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use {
    	"TimUntersberger/neogit", -- Git
    	requires = "nvim-lua/plenary.nvim",
  }
  use {
      	'nvim-telescope/telescope.nvim', -- Fuzzy finder
      	requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
  use {
	"windwp/nvim-autopairs",
    	config = function() require("nvim-autopairs").setup {} end
}
end)

