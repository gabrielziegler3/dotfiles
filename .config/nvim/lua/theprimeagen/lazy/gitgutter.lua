-- add gitgutter
return {
    "airblade/vim-gitgutter",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        vim.keymap.set("n", "gu", "<cmd>GitGutterNextHunk<CR>")
        vim.keymap.set("n", "gh", "<cmd>GitGutterPrevHunk<CR>")
    end
}
