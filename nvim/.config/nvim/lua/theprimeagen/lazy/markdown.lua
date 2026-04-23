return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- Configuration options
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ''
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {}
      }
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_port = ''
      vim.g.mkdp_page_title = '「${name}」'
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
  },
  {
    "ellisonleao/glow.nvim", 
    config = function()
      require("glow").setup({
        style = "dark", -- filled automatically with your current editor background, you can override using glow json style
        width = 120,
        height = 100,
        width_ratio = 0.8, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
        height_ratio = 0.8,
      })
    end, 
    cmd = "Glow",
    keys = {
      { "<leader>mg", "<cmd>Glow<cr>", desc = "Glow Preview (Terminal)", ft = "markdown" },
    },
  },
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "text" },
    config = function()
      -- Enable table mode for markdown files
      vim.g.table_mode_corner = '|'
      vim.g.table_mode_header_fillchar = '-'
      vim.g.table_mode_align_char = ':'
      vim.g.table_mode_delimiter = ' | '
      vim.g.table_mode_fillchar = '-'
      
      -- Auto-enable table mode for markdown files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.cmd("TableModeEnable")
        end,
      })
    end,
    keys = {
      { "<leader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle Table Mode", ft = "markdown" },
      { "<leader>tr", "<cmd>TableModeRealign<cr>", desc = "Realign Table", ft = "markdown" },
      { "<leader>tt", "<cmd>Tableize<cr>", desc = "Convert to Table", ft = "markdown", mode = "v" },
      { "<leader>tdd", "<cmd>TableModeDeleteRow<cr>", desc = "Delete Table Row", ft = "markdown" },
      { "<leader>tdc", "<cmd>TableModeDeleteColumn<cr>", desc = "Delete Table Column", ft = "markdown" },
      { "<leader>tic", "<cmd>TableModeInsertColumn<cr>", desc = "Insert Table Column", ft = "markdown" },
    },
  },
  {
    "preservim/vim-markdown",
    ft = { "markdown" },
    config = function()
      -- Disable folding
      vim.g.vim_markdown_folding_disabled = 1
      -- Enable strikethrough
      vim.g.vim_markdown_strikethrough = 1
      -- Enable frontmatter
      vim.g.vim_markdown_frontmatter = 1
      -- Enable TOML frontmatter
      vim.g.vim_markdown_toml_frontmatter = 1
      -- Enable JSON frontmatter
      vim.g.vim_markdown_json_frontmatter = 1
      -- Follow anchors
      vim.g.vim_markdown_follow_anchor = 1
      -- Auto insert bullets
      vim.g.vim_markdown_auto_insert_bullets = 1
      -- New list item in insert mode
      vim.g.vim_markdown_new_list_item_indent = 2
    end,
  },
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text" },
    config = function()
      vim.g.bullets_enabled_file_types = { 'markdown', 'text', 'gitcommit' }
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_set_mappings = 1
      vim.g.bullets_outline_levels = { 'ROM', 'ABC', 'num', 'abc', 'rom', 'star' }
      vim.g.bullets_renumber_on_change = 1
      vim.g.bullets_nested_checkboxes = 1
      vim.g.bullets_checkbox_markers = ' .oOX'
      vim.g.bullets_max_alpha_characters = 2
      vim.g.bullets_outline_levels = { 'std*', 'std-' }
    end,
  },
}
