return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")
    notify.setup({
      background_colour = "#000000",
      fps = 30,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = ""
      },
      level = 2,
      minimum_width = 50,
      render = "compact",
      stages = "fade_in_slide_out",
      time_formats = {
        notification = "%T",
        notification_history = "%FT%T"
      },
      timeout = 5000,
      top_down = true
    })
    
    -- Set as default notify function
    vim.notify = notify
  end,
}
