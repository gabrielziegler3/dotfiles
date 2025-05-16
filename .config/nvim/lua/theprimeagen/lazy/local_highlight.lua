return {
  {
    'tzachar/local-highlight.nvim',
    dependencies = {
        "folke/snacks.nvim"
    },
    config = function()
      require('local-highlight').setup({
        animation = false, -- disable animation to avoid needing snacks.nvim
      })
    end,
    event = 'BufRead',
  }
}

