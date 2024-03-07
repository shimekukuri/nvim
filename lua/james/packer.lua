-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use { "catppuccin/nvim", as = "catppuccin" }

  use({ 'svrana/neosolarized.nvim' })

  use({ 'tjdevries/colorbuddy.nvim' })

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use({ 'nvim-lualine/lualine.nvim' })
  use('nvim-treesitter/playground')
  use('theprimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      --- Uncomment these if you want to manage LSP servers from neovim
      -- {'williamboman/mason.nvim'},
      -- {'williamboman/mason-lspconfig.nvim'},

      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
    }
  }

  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  use {
    "windwp/nvim-ts-autotag"
  }
  use {
    "windwp/nvim-autopairs"
  }
  use('MunifTanjim/prettier.nvim')
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
  })

  use("lukas-reineke/indent-blankline.nvim")

  use {
    "folke/trouble.nvim",
    requires =  {
      { "nvim-tree/nvim-web-devicons" }
    }

  }
end)
