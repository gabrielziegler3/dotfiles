return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_node_command = "node"
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_enabled = true

    -- Use Tab to accept Copilot suggestion
    vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<Tab>")', {
      expr = true,
      silent = true,
      noremap = true,
      replace_keycodes = false
    })
  end
}

