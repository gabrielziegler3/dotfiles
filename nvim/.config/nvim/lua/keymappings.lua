local utils = require('utils')
utils.map('n', '<C-n>', ':NvimTreeToggle<CR>') -- Clear highlights

-- Run pandoc on current document
vim.api.nvim_set_keymap('n', '<F5>', [[<Cmd>w<CR><Cmd>silent !docker run --rm --volume "$(pwd):/data" --user $(id -u):$(id -g) pandoc/latex % -o %:r.pdf<CR>]], { noremap = true, silent = true })


