local fn = vim.fn

-- local function get_config_dir()
--   local lvim_config_dir = os.getenv "NVIM_CONFIG_DIR"
--   if not lvim_config_dir then
--     return vim.call("stdpath", "config")
--   end
--   return lvim_config_dir
-- end
--
-- local function join_paths(...)
--   local result = table.concat({ ... }, path_sep)
--   return result
-- end

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
  use "nvim-lua/popup.nvim"    -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim"  -- Useful lua functions used ny lots of plugins
  use { "Tastyep/structlog.nvim", commit = "c527d97" }
  use "kyazdani42/nvim-web-devicons"
  use "antoinemadec/FixCursorHold.nvim"
  use "tpope/vim-dispatch"

  -- Core Plugins --
  -- use 'lewis6991/impatient.nvim'
  use "windwp/nvim-autopairs"
  -- use(join_paths(get_config_dir(), "forked/nvim-autopairs"))
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
  use "tpope/vim-surround"

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
  -- use "williamboman/nvim-lsp-installer"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
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
  use "nvim-treesitter/playground"

  -- Colors --
  --[[ use 'phanviet/vim-monokai-pro' ]]
  use 'xiyaowong/nvim-transparent'
  --[[ use { ]]
  --[[   'https://gitlab.com/__tpb/monokai-pro.nvim', ]]
  --[[   as = 'monokai-pro.nvim' ]]
  --[[ } ]]
  --[[ use 'p00f/nvim-ts-rainbow' ]]
  --[[ use 'https://gitlab.com/__tpb/monokai-pro.nvim' ]]
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
  -- use(join_paths(get_config_dir(), "symbols-outline"))
  -- use 'simrat39/symbols-outline.nvim'
  -- use 'stevearc/aerial.nvim'

  -- Documentation --
  use 'mzlogin/vim-markdown-toc'
  use { 'heavenshell/vim-jsdoc', run = 'make install', ft = { 'typescript', 'typescriptreact', 'javascript',
    'javascriptreact' } }
  -- use 'tjdevries/tree-sitter-lua'

  -- Debugging --
  use 'mfussenegger/nvim-dap'
  -- use(join_paths(get_config_dir(), "forked/nvim-dap"))
  use "rcarriga/nvim-dap-ui"
  -- use(join_paths(get_config_dir(), "forked/nvim-dap-ui"))
  use "theHamsta/nvim-dap-virtual-text"

  use {
    "microsoft/vscode-js-debug",
    opt = true,
    run = "npm install --legacy-peer-deps && npx gulp dapDebugServer"
  }

  use(join_paths(get_config_dir(), "forked/nvim-dap-vscode-js"))

  -- use { "mxsdev/nvim-dap-vscode-js", requires = {"mfussenegger/nvim-dap"} }
  use "nvim-neotest/neotest"
  use "haydenmeade/neotest-jest"
  -- use(join_paths(get_config_dir(), "forked/neotest-jest"))
  -- use "vim-test/vim-test"
  -- use "rcarriga/vim-ultest"

  -- Editing --
  --[[ use 'mg979/vim-visual-multi' ]]

  -- Markdown --
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  })

  use 'lervag/vimtex'

  use "smjonas/snippet-converter.nvim"

  use 'ThePrimeagen/vim-be-good'

  --[[ use { ]]
  --[[   "jesseleite/nvim-noirbuddy", ]]
  --[[   requires = { "tjdevries/colorbuddy.nvim", branch = "dev" } ]]
  --[[ } ]]
  --[[ use {  ]]
  --[[   'olivercederborg/poimandres.nvim', ]]
  --[[   config = function() ]]
  --[[     require('poimandres').setup { ]]
  --[[       -- leave this setup function empty for default config ]]
  --[[       -- or refer to the configuration section ]]
  --[[       -- for configuration options ]]
  --[[     } ]]
  --[[   end ]]
  --[[ } ]]

  use "AndrewRadev/splitjoin.vim"

  use "sainnhe/everforest"

  --[[ if get_config_dir ~= nil then ]]
  --[[   use(join_paths(get_config_dir(), "forked/everforest")) ]]
  --[[ end ]]

  --[[ use "SirVer/ultisnips" ]]
  --[[ use "quangnguyen30192/cmp-nvim-ultisnips" ]]

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
