return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        -- Neovim 0.11.2 can finish an async parse after a transient window
        -- (for example, a Telescope preview) has already closed. Parsing
        -- synchronously avoids the resulting "Invalid window id" redraw.
        vim.g._ts_force_sync_parsing = true

        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {
                "c",
                "lua", 
                "vim",
                "vimdoc",
                "query",
                "javascript",
                "typescript",
                "html",
                "css",
                "python",
                "json",
                "bash",
                "markdown",
                "markdown_inline",
            },
            sync_install = false,
            auto_install = true,
            highlight = { 
                enable = true,
                -- Disable for problematic parsers
                disable = { "latex" },
            },
            indent = { 
                enable = true,
                -- Disable for problematic parsers
                disable = { "latex" },
            },
        })
    end
}
