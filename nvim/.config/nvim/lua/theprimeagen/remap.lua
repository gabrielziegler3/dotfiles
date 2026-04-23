
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set("n", "<F3>", "<cmd>silent !compilation_files/compile full<CR>", { silent = true })

-- nvim tree ctrl+n
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>")

-- Optimized movement keys for fast key repeat
-- These temporarily disable scroll animations during rapid movement
local function create_movement_map(key, desc)
  vim.keymap.set("n", key, function()
    require('mini.animate').config.scroll.enable = false
    vim.cmd('normal! ' .. key)
    vim.defer_fn(function()
      require('mini.animate').config.scroll.enable = true
    end, 50) -- Shorter delay for basic movements
  end, { desc = desc .. " (optimized for fast repeat)" })
end

-- Basic movement keys
create_movement_map("j", "Down")
create_movement_map("k", "Up") 
create_movement_map("h", "Left")
create_movement_map("l", "Right")

-- Paragraph navigation
create_movement_map("{", "Previous paragraph")
create_movement_map("}", "Next paragraph")

-- Other common movement keys that might cause issues
create_movement_map("<C-d>", "Half page down")
create_movement_map("<C-u>", "Half page up")
create_movement_map("<C-f>", "Page down")
create_movement_map("<C-b>", "Page up")
create_movement_map("G", "Go to end")
create_movement_map("gg", "Go to start")

-- Markdown formatting keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local opts = { buffer = true, silent = true }
    
    -- Text formatting
    vim.keymap.set("v", "<leader>mb", "c**<C-r>\"**<Esc>", vim.tbl_extend("force", opts, { desc = "Bold text" }))
    vim.keymap.set("v", "<leader>mi", "c*<C-r>\"*<Esc>", vim.tbl_extend("force", opts, { desc = "Italic text" }))
    vim.keymap.set("v", "<leader>mc", "c`<C-r>\"`<Esc>", vim.tbl_extend("force", opts, { desc = "Inline code" }))
    vim.keymap.set("v", "<leader>ms", "c~~<C-r>\"~~<Esc>", vim.tbl_extend("force", opts, { desc = "Strikethrough" }))
    
    -- Links and images
    vim.keymap.set("v", "<leader>ml", "c[<C-r>\"]()<Esc>i", vim.tbl_extend("force", opts, { desc = "Create link" }))
    vim.keymap.set("v", "<leader>mI", "c![<C-r>\"]()<Esc>i", vim.tbl_extend("force", opts, { desc = "Create image" }))
    
    -- Headers (normal mode)
    vim.keymap.set("n", "<leader>m1", "I# <Esc>", vim.tbl_extend("force", opts, { desc = "H1 header" }))
    vim.keymap.set("n", "<leader>m2", "I## <Esc>", vim.tbl_extend("force", opts, { desc = "H2 header" }))
    vim.keymap.set("n", "<leader>m3", "I### <Esc>", vim.tbl_extend("force", opts, { desc = "H3 header" }))
    vim.keymap.set("n", "<leader>m4", "I#### <Esc>", vim.tbl_extend("force", opts, { desc = "H4 header" }))
    
    -- Lists
    vim.keymap.set("n", "<leader>m-", "I- <Esc>A", vim.tbl_extend("force", opts, { desc = "Bullet point" }))
    vim.keymap.set("n", "<leader>m*", "I* <Esc>A", vim.tbl_extend("force", opts, { desc = "Bullet point (*)" }))
    vim.keymap.set("n", "<leader>mx", "I- [ ] <Esc>A", vim.tbl_extend("force", opts, { desc = "Checkbox" }))
    vim.keymap.set("n", "<leader>mX", "I- [x] <Esc>A", vim.tbl_extend("force", opts, { desc = "Checked checkbox" }))
    
    -- Code blocks
    vim.keymap.set("n", "<leader>mCB", "o```<CR>```<Esc>O", vim.tbl_extend("force", opts, { desc = "Code block" }))
    vim.keymap.set("v", "<leader>mCB", "c```<CR><C-r>\"<CR>```<Esc>", vim.tbl_extend("force", opts, { desc = "Wrap in code block" }))
    
    -- Quick table creation
    vim.keymap.set("n", "<leader>mT", function()
      local lines = {
        "| Header 1 | Header 2 | Header 3 |",
        "|----------|----------|----------|",
        "| Cell 1   | Cell 2   | Cell 3   |",
        "| Cell 4   | Cell 5   | Cell 6   |"
      }
      vim.api.nvim_put(lines, "l", true, true)
    end, vim.tbl_extend("force", opts, { desc = "Insert table template" }))
    
    -- Format current table (requires vim-table-mode)
    vim.keymap.set("n", "<leader>mf", "<cmd>TableModeRealign<cr>", vim.tbl_extend("force", opts, { desc = "Format current table" }))
    
    -- Toggle checkboxes
    vim.keymap.set("n", "<leader>mtc", function()
      local line = vim.api.nvim_get_current_line()
      local new_line
      if line:match("%- %[ %]") then
        new_line = line:gsub("%- %[ %]", "- [x]")
      elseif line:match("%- %[x%]") then
        new_line = line:gsub("%- %[x%]", "- [ ]")
      else
        return
      end
      vim.api.nvim_set_current_line(new_line)
    end, vim.tbl_extend("force", opts, { desc = "Toggle checkbox" }))
  end,
})

