return {
    "github/copilot.vim",
    -- accept with tab
    config = function()
        vim.g.copilot_node_command = "node"
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_enabled = true
     end
    }
