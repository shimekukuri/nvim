require("trouble").setup({
})

vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = "Diagnostics (Trouble)" })
vim.api.nvim_set_keymap('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
  { desc = "Buffer Diagnostics (Trouble)" })
vim.api.nvim_set_keymap('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = "Symbols (Trouble)" })
vim.api.nvim_set_keymap('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
  { desc = "LSP Definitions / references / ... (Trouble)" })
vim.api.nvim_set_keymap('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = "Location List (Trouble)" })
vim.api.nvim_set_keymap('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = "Quickfix List (Trouble)" })
