lvim.plugins = {
  { "lunarvim/colorschemes" },
  {
    "sainnhe/everforest",
  },
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({})
    end
  },
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  {
    "tpope/vim-surround",
  },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      require("gitblame").setup { enabled = false }
    end,
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      -- OR 'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require "octo".setup()
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust' },
  },
  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      -- you also will likely want nvim-cmp or some completion engine
    },

    -- see details below for full configuration options
    opts = {
      lsp = {
        on_attach = on_attach,
      },
      mappings = true,
    }
  }
}

-- lvim.transparent_window = true

lvim.format_on_save.enabled = true

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    name = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    -- args = { "--print-width", "100" },

    ---@usage only start in these filetypes, by default it will attach to all filetypes it supports
    filetypes = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact"
    },
  },
}


lvim.colorscheme = "everforest"
lvim.builtin.telescope.theme = "center"

lvim.builtin.lualine.style = "default"

lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.nvimtree.setup.filters.dotfiles = false

lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

lvim.keys.insert_mode["<A-Backspace>"] = "<Esc><Right>dbi"
lvim.keys.insert_mode["<C-Backspace>"] = "<Esc><Right>dbi"

-- TODO: move this to normal mapping
vim.api.nvim_exec("noremap <expr> k v:count ? 'k' : 'gk'", false)
vim.api.nvim_exec("noremap <expr> j v:count ? 'j' : 'gj'", false)

for _, mode in pairs({ "normal_mode", "visual_mode", "visual_block_mode" }) do
  lvim.keys[mode] = vim.tbl_extend('error', lvim.keys[mode], {
    -- Disable copy on clear
    ["c"] = '"_c',

    -- Disable copy on delete
    ["d"] = '"_d'
  })
end

lvim.autocommands = {
  {
    { "ColorScheme" },
    {
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#414846" })
        vim.api.nvim_set_hl(0, "Search", { italic = true, underline = true, bold = true })

        -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { ctermbg="none", bg="none" })
        -- vim.api.nvim_set_hl(0, "MsgArea", { ctermbg="none", bg="none" })
        -- vim.api.nvim_set_hl(0, "TelescopeBorder", { ctermbg="none", bg="none" })
      end
    },
    {
      "TextYankPost",
      {
        group = "_general_settings_2",
        pattern = "*",
        desc = "Highlight text on yank",
        callback = function()
          vim.highlight.on_yank { higroup = "Search", timeout = 200 }
        end,
      },
    },
  }
}

-- cmd "au ColorScheme * hi NvimTreeNormal ctermbg=none guibg=none"

lvim.builtin.lualine.options.component_separators = { left = "", right = "" }
lvim.builtin.lualine.options.section_separators = { left = "", right = "" }
lvim.builtin.lualine.sections.lualine_a = {
  {
    function()
      return " "
    end,
    padding = { left = 0, right = 0 },
    color = {},
    cond = nil,
  }
}

lvim.builtin.bufferline.options = {
  numbers = "none",                        -- can be "none" | "ordinal" | "buffer_id" | "both" | function
  close_command = "bdelete! %d",           -- can be a string | function, see "Mouse actions"
  right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
  left_mouse_command = "buffer %d",        -- can be a string | function, see "Mouse actions"
  middle_mouse_command = nil,              -- can be a string | function, see "Mouse actions"
  -- NOTE: this plugin is designed with this icon in mind,
  -- and so changing this is NOT recommended, this is intended
  -- as an escape hatch for people who cannot bear it for whatever reason
  indicator = { style = "icon", icon = "▎" },
  buffer_close_icon = "󰅖",
  modified_icon = "●",
  close_icon = "",
  left_trunc_marker = "",
  right_trunc_marker = "",
  --- name_formatter can be used to change the buffer's label in the bufferline.
  --- Please note some names can/will break the
  --- bufferline so use this at your discretion knowing that it has
  --- some limitations that will *NOT* be fixed.
  name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
    -- remove extension from markdown files for example
    if buf.name:match "%.md" then
      return vim.fn.fnamemodify(buf.name, ":t:r")
    end
  end,
  max_name_length = 18,
  max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
  tab_size = 18,
  diagnostics = "nvim_lsp",
  diagnostics_update_in_insert = false,
  diagnostics_indicator = diagnostics_indicator,
  -- NOTE: this will be called a lot so don't do any heavy processing here
  custom_filter = custom_filter,
  offsets = {
    {
      filetype = "undotree",
      -- text = "Undotree",
      -- highlight = "PanelHeading",
      padding = 1,
    },
    {
      filetype = "NvimTree",
      -- text = "~ Explorer ~",
      -- highlight = "BufferLineBackground",
      padding = 1,
    },
    {
      filetype = "DiffviewFiles",
      -- text = "Diff View",
      -- highlight = "PanelHeading",
      padding = 1,
    },
    {
      filetype = "flutterToolsOutline",
      -- text = "Flutter Outline",
      -- highlight = "PanelHeading",
    },
    {
      filetype = "packer",
      -- text = "Packer",
      -- highlight = "PanelHeading",
      padding = 1,
    },
  },
  -- show_buffer_icons = userconf.use_icons, -- disable filetype icons for buffers
  -- show_buffer_close_icons = userconf.use_icons,
  show_close_icon = false,
  show_tab_indicators = true,
  persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
  -- can also be a table containing 2 custom separators
  -- [focused and unfocused]. eg: { '|', '|' }
  separator_style = "thin",
  enforce_regular_tabs = false,
  always_show_bufferline = true,
  sort_by = "id",
}

local vim_options = {
  title = true,
  backup = false,                          -- creates a backup file
  clipboard = "unnamed",                   -- allows neovim to access the system clipboard
  cmdheight = 1,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  -- mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 1000,                       -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  cursorline = false,                      -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = true,                             -- display lines as one long line
  scrolloff = 8,                           -- is one of my fav
  sidescrolloff = 8,
  guifont = "FiraCode NerdFont Mono:17",   -- the font used in graphical neovim applications
  errorbells = false,
  incsearch = true,
  hidden = true,
  autoindent = true,
  laststatus = 3,
}

for k, v in pairs(vim_options) do
  vim.opt[k] = v
end

vim.opt.showmode         = false

vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
