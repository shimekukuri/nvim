local telescope = require("telescope")
local builtin = require('telescope.builtin')
local open_with_trouble = require("trouble.sources.telescope").open

telescope.setup({
  defaults = {
    mappings = {
      i = { ["<leader>m"] = open_with_trouble },
    },
  },
})

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
--[[vim.keymap.set('n', '<leader>m', builtin.diagnostics, {})]] --
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
