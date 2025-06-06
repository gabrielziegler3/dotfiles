local g = vim.g
local opt = vim.opt

-- Remap leader and local leader to <Space>
-- api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
-- g.mapleader = " "
-- g.maplocalleader = " "

opt.termguicolors = true -- Enable colors in terminal
opt.hlsearch = true --Set highlight on search
opt.number = true --Make line numbers default
-- opt.relativenumber = true --Make relative number default
opt.breakindent = true --Enable break indent
opt.undofile = true --Save undo history
opt.ignorecase = true --Case insensitive searching unless /C or capital in search
opt.smartcase = true -- Smart case
opt.updatetime = 250 --Decrease update time
opt.signcolumn = "yes" -- Always show sign column
opt.tabstop = 4
opt.shiftwidth = 4
vim.cmd('set expandtab')

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Copilot
g.copilot_assume_mapped = true
g.copilot_filetypes = {
    markdown = true,
}
