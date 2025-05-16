return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({
            defaults = {
                path_display = { 'smart' },
                prompt_prefix = '❯ ',
                selection_caret = '❯ ',
                layout_config = {
                    width = 0.9,
                    height = 0.9,
                    prompt_position = 'top',
                    preview_cutoff = 120,
                    horizontal = {
                        preview_width = 0.6,
                    },
                    vertical = {
                        preview_height = 0.5,
                    },
                },
                preview = {
                    title = true,
                    title_hook = function(filepath)
                        return filepath
                    end,
                },
            },
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

        vim.keymap.set('n', '<leader>fw', function()
            builtin.live_grep({ default_text = vim.fn.expand("<cword>") })
        end, { desc = 'Telescope live grep word under cursor' })
    end
}

