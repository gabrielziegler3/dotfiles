return {
  'echasnovski/mini.animate',
  version = false,
  config = function()
    require('mini.animate').setup({
      -- Cursor path
      cursor = {
        enable = true,
        timing = require('mini.animate').gen_timing.linear({ duration = 50, unit = 'total' }),
        path = require('mini.animate').gen_path.line({
          predicate = function() return true end,
        }),
      },
      -- Vertical scroll - optimized for fast key repeat
      scroll = {
        enable = true,
        timing = require('mini.animate').gen_timing.linear({ duration = 80, unit = 'total' }),
        subscroll = require('mini.animate').gen_subscroll.equal({
          predicate = function(total_scroll)
            -- Disable animation for large scrolls (fast key repeat)
            return math.abs(total_scroll) < 10
          end,
        }),
      },
      -- Window resize
      resize = {
        enable = true,
        timing = require('mini.animate').gen_timing.linear({ duration = 80, unit = 'total' }),
      },
      -- Window open
      open = {
        enable = true,
        timing = require('mini.animate').gen_timing.linear({ duration = 120, unit = 'total' }),
        winconfig = require('mini.animate').gen_winconfig.wipe({ direction = 'from_edge' }),
      },
      -- Window close
      close = {
        enable = true,
        timing = require('mini.animate').gen_timing.linear({ duration = 120, unit = 'total' }),
        winconfig = require('mini.animate').gen_winconfig.wipe({ direction = 'to_edge' }),
      },
    })
  end,
}
