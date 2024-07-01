require("trouble").setup({
  icons = true,
  warn_no_results = false,
  open_no_results = true
})

vim.keymap.set("n", "<leader>tt", function()
  require("trouble").toggle()
end)

vim.keymap.set("n", "[t", function()
  require("trouble").next({ skep_groups = true, jump = true });
end)

vim.keymap.set("n", "[t", function()
  require("trouble").previous({ skep_groups = true, jump = true });
end)

