return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- animate cursor movements (disabled since we use mini.animate)
    animate = { enabled = false },
    -- bigfile detection
    bigfile = { enabled = true },
    -- dashboard on startup
    dashboard = { enabled = false }, -- disable dashboard since you might prefer a simpler startup
    -- git integration
    git = { enabled = true },
    -- gitbrowse integration
    gitbrowse = { enabled = true },
    -- lazygit integration
    lazygit = { enabled = true },
    -- notification system (disabled since we use nvim-notify)
    notify = { enabled = false },
    -- quickfile for fast file operations
    quickfile = { enabled = true },
    -- statuscolumn enhancements
    statuscolumn = { enabled = true },
    -- terminal integration
    terminal = { enabled = true },
    -- toggle features
    toggle = { enabled = true },
    -- words highlighting
    words = { enabled = true },
    -- indent guides (disabled since we use indent-blankline.nvim)
    indent = { enabled = false },
    -- input dialog
    input = { enabled = true },
    -- explorer file tree
    explorer = { enabled = false }, -- disable since you already have nvim-tree
    -- scratch buffers
    scratch = { enabled = true },
    -- zen mode
    zen = { enabled = true },
  },
  keys = {
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>", function() Snacks.terminal() end, desc = "Toggle Terminal" }, -- which-key shows this as <c-_>
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        if vim.lsp.inlay_hint then
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end
      end,
    })
  end,
}
