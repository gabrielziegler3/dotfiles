return {
  {
    'tzachar/local-highlight.nvim',
    dependencies = {
        "folke/snacks.nvim"
    },
    config = function()
      require('local-highlight').setup({
        animation = true, -- enable animations with snacks.nvim
        file_types = {'*'}, -- enable for all filetypes
        hlgroup = 'Search',
        cw_hlgroup = nil,
        insert_mode = false,
      })
    end,
    event = 'BufRead',
  }
}

