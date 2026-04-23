-- add gitgutter
return {
    "airblade/vim-gitgutter",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        vim.keymap.set("n", "<leader>gd", vim.cmd.GitGutterPreviewHunk)
    end
}
