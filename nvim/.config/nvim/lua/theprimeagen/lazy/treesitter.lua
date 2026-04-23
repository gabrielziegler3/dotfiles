return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
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
