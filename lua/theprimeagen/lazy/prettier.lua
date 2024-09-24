return {
    "prettier/vim-prettier",
    ft = "javascript",
    pin = true,
    config = function()
        -- sudo npm install -g prettier
        -- config options: https://prettier.io/docs/en/options
        -- .prettierrc
        vim.cmd([[
		"avoid error info write to header of buffer
		let g:prettier#exec_cmd_async = 1

        nnoremap <silent> ,f :Prettier<cr>
      ]])
    end,
}
