local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path, nil, nil)) > 0 then -- luacheck: ignore
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use) 
  -- Libraries --
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "Tastyep/structlog.nvim"
  use "kyazdani42/nvim-web-devicons"

  -- Core Plugins --
  use "windwp/nvim-autopairs"
  use "numToStr/Comment.nvim"
  use "kyazdani42/nvim-tree.lua"
  use "akinsho/toggleterm.nvim"
  use "folke/which-key.nvim"
  use "akinsho/bufferline.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-fzf-native.nvim"
  use "lewis6991/gitsigns.nvim"
  use "nvim-lualine/lualine.nvim"
  use {
    "max397574/lua-dev.nvim",
    module = "lua-dev",
  }
  use "ahmedkhalf/project.nvim"
  use "goolord/alpha-nvim"
  use "windwp/nvim-ts-autotag"
  
  -- CMP Plugins --
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "saadparwaiz1/cmp_luasnip"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-nvim-lua"
  
  --- LSP ---
  use "neovim/nvim-lspconfig"
  use "tamago324/nlsp-settings.nvim"
  use "williamboman/nvim-lsp-installer"
  use "b0o/schemastore.nvim"
  use "jose-elias-alvarez/null-ls.nvim"
  use "jose-elias-alvarez/nvim-lsp-ts-utils"
  use "ray-x/lsp_signature.nvim"
  
  -- TreeSitter --
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Colors --
  use 'phanviet/vim-monokai-pro'
  use 'xiyaowong/nvim-transparent'
  use 'p00f/nvim-ts-rainbow'
  use 'https://gitlab.com/__tpb/monokai-pro.nvim'
  -- use "folke/todo-comments.nvim"

  -- Motion / Syntax --
  -- use "mfussenegger/nvim-ts-hint-textobject"
  use {
    'Gelio/nvim-treehopper',
    branch = 'resolve-parser-lang'
  }
  use 'ggandor/lightspeed.nvim'
  use "ziontee113/syntax-tree-surfer"
  use "ThePrimeagen/refactoring.nvim"
  use(join_paths(get_config_dir(), "symbols-outline"))
  -- use 'simrat39/symbols-outline.nvim'
  -- use 'stevearc/aerial.nvim'

  -- Documentation --
  use 'mzlogin/vim-markdown-toc'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
