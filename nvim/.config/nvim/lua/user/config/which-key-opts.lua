local fake_leader = true
local leader_key = (fake_leader and "⋉") or "<leader>"

-- vim.keymap.set('n', "<leader>", [[<Cmd>lua require("which-key").show("⋉", {mode = "n", auto = true})<CR>]])

local M = {
  ---@usage disable which-key completely [not recommended]
  active = true,
  leader_key = leader_key,
  on_config_done = function(wk)
    if not fake_leader then
      return
    end

    for _, mode in pairs({ 'n', 'v', 'x' }) do
      vim.keymap.set(mode, "<leader>", [[<Cmd>lua require("which-key").show("]] .. leader_key .. [[", {mode = "]] .. mode .. [[", auto = true})<CR>]])
    end
  end,
  setup = {
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      presets = {
        operators = false, -- adds help for operators like d, y, ...
        motions = false, -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = false, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
      spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
      border = "single", -- none, single, double, shadow
      position = "bottom", -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    show_help = true, -- show help message on the command line when the popup is visible
    -- triggers = "auto", -- automatically setup triggers
    triggers = { leader_key }, -- or specify a list manually
    -- triggers = { },
    triggers_nowait = { leader_key },
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for key maps that start with a native binding
      -- most people should not need to change this
      i = { "j", "k" },
      v = { "j", "k" },
    },
  },

  opts = {
    mode = "n", -- NORMAL mode
    prefix = leader_key,
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  },
  vopts = {
    mode = "v", -- VISUAL mode
    prefix = leader_key,
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  },
  xopts = {
    mode = "x",
    prefix = leader_key,
    buffer = nil,
    silent = true, noremap = true, nowait = true
  },
  -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
  -- see https://neovim.io/doc/user/map.html#:map-cmd
  vmappings = {
    ["/"] = { "<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>", "Comment" },
    r = {
      name = "Refactor",
      e = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], "Extract Function" },
      f = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], "Extract Function to File" },
      v = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], "Extract Variable" },
      i = { [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], "Inline Variable" },
    },
  },
  xmappings = {
    R = {
      name = "Refactor",
      e = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], "Extract Function" },
      f = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], "Extract Function to File" },
      v = { [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], "Extract Variable" },
      i = { [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], "Inline Variable" },
    },
  },
  mappings = {
    R = {
      name = "Refactor",
      b = { [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], "Extract Block" },
      B = { [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], "Extract Block to File" },
      i = { [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], "Inline Variable" },
    },
    d = { "<cmd>SymbolsOutline<CR>", "Outline" },
    [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
    ["w"] = { "<cmd>w!<CR>", "Save" },
    ["q"] = { "<cmd>lua require('user.utils.functions').smart_quit()<CR>", "Quit" },
    -- ["/"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },
    ["c"] = { "<cmd>BufferKill<CR>", "Close Buffer" },
    ["f"] = { "<cmd>lua require('user.core.telescope.custom-finders').find_project_files()<cr>", "Find File" },
    ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
    ["p"] = { "<cmd>Telescope projects<CR>", "Project" },
    ["["] = { "`[V`]<", "De-Indent Pasted Block" },
    ["]"] = { "`[V`]>", "Indent Pasted Block" },
    b = {
      name = "Buffers",
      j = { "<cmd>BufferLinePick<cr>", "Jump" },
      f = { "<cmd>Telescope buffers<cr>", "Find" },
      b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
      -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
      e = {
        "<cmd>BufferLinePickClose<cr>",
        "Pick which buffer to close",
      },
      h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
      l = {
        "<cmd>BufferLineCloseRight<cr>",
        "Close all to the right",
      },
      o = {
        "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>",
        "Close all others"
      },
      D = {
        "<cmd>BufferLineSortByDirectory<cr>",
        "Sort by directory",
      },
      L = {
        "<cmd>BufferLineSortByExtension<cr>",
        "Sort by language",
      },
    },
    P = {
      name = "Packer",
      c = { "<cmd>PackerCompile<cr>", "Compile" },
      i = { "<cmd>PackerInstall<cr>", "Install" },
      -- r = { "<cmd>lua require('lvim.plugin-loader').recompile()<cr>", "Re-compile" },
      s = { "<cmd>PackerSync<cr>", "Sync" },
      S = { "<cmd>PackerStatus<cr>", "Status" },
      u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    -- " Available Debug Adapters:
    -- "   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
    -- " Adapter configuration and installation instructions:
    -- "   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -- " Debug Adapter protocol:
    -- "   https://microsoft.github.io/debug-adapter-protocol/
    -- " Debugging
    g = {
      name = "Git",
      j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
      k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
      l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
      p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
      r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
      R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
      s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
      u = {
        "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
        "Undo Stage Hunk",
      },
      o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
      b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
      c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
      C = {
        "<cmd>Telescope git_bcommits<cr>",
        "Checkout commit(for current file)",
      },
      d = {
        "<cmd>Gitsigns diffthis HEAD<cr>",
        "Git Diff",
      },
    },
    l = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
      w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
      f = { "<cmd>lua require('user.lsp.utils').format()<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
      j = {
        vim.diagnostic.goto_next,
        "Next Diagnostic",
      },
      k = {
        vim.diagnostic.goto_prev,
        "Prev Diagnostic",
      },
      l = { vim.lsp.codelens.run, "CodeLens Action" },
      p = {
        name = "Peek",
        d = { "<cmd>lua require('user.lsp.peek').Peek('definition')<cr>", "Definition" },
        t = { "<cmd>lua require('user.lsp.peek').Peek('typeDefinition')<cr>", "Type Definition" },
        i = { "<cmd>lua require('user.lsp.peek').Peek('implementation')<cr>", "Implementation" },
      },
      t = {
        name = "TypeScript",
        i = { "<cmd>TSLspImportCurrent<cr>", "Import" },
        I = { "<cmd>TSLspImportAll<cr>", "Import All" },
        o = { "<cmd>TSLspOrganize<cr>", "Organize Imports" },
        r = { "<cmd>TSLspRenameFile<cr>", "Rename File" },
        h = { "<cmd>TSLspToggleInlayHints<cr>", "Toggle Inlay Hints" },
      },
      q = { vim.diagnostic.setloclist, "Quickfix" },
      r = { vim.lsp.buf.rename, "Rename" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
      S = {
        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        "Workspace Symbols",
      },
      e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
    },
    i = {
      name = "+IDE",
      -- c = {
      --   "<cmd>edit " .. get_config_dir() .. "/config.lua<cr>",
      --   "Edit config.lua",
      -- },
      D = { "<cmd>lua require('user.debug')()<cr>", "Run debug"},
      f = { "<CMD>Telescope oldfiles<CR>", "Recent Files" },
      F = { "<CMD>lua require('user.utils.history').open_recent_file()<CR>", "Open Recent File" },
      -- f = {
      --   "<cmd>lua require('lvim.core.telescope.custom-finders').find_lunarvim_files()<cr>",
      --   "Find LunarVim files",
      -- },
      g = {
        "<cmd>lua require('lvim.core.telescope.custom-finders').grep_lunarvim_files()<cr>",
        "Grep LunarVim files",
      },
      k = { "<cmd>Telescope keymaps<cr>", "View LunarVim's keymappings" },
      i = {
        "<cmd>lua require('user.info').toggle_popup(vim.bo.filetype)<cr>",
        "Toggle IDE Info",
      },
      I = {
        "<cmd>lua require('lvim.core.telescope.custom-finders').view_lunarvim_changelog()<cr>",
        "View LunarVim's changelog",
      },
      l = {
        name = "+logs",
        d = {
          "<cmd>lua require('user.core.terminal').toggle_log_view(require('user.log').get_path())<cr>",
          "view default log",
        },
        D = {
          "<cmd>lua vim.fn.execute('edit ' .. require('user.log').get_path())<cr>",
          "Open the default logfile",
        },
        l = {
          "<cmd>lua require('user.core.terminal').toggle_log_view(vim.lsp.get_log_path())<cr>",
          "view lsp log",
        },
        L = { "<cmd>lua vim.fn.execute('edit ' .. vim.lsp.get_log_path())<cr>", "Open the LSP logfile" },
        n = {
          "<cmd>lua require('user.core.terminal').toggle_log_view(os.getenv('NVIM_LOG_FILE'))<cr>",
          "view neovim log",
        },
        N = { "<cmd>edit $NVIM_LOG_FILE<cr>", "Open the Neovim logfile" },
        p = {
          "<cmd>lua require('user.core.terminal').toggle_log_view(get_cache_dir() .. '/packer.nvim.log')<cr>",
          "view packer log",
        },
        P = { "<cmd>edit $LUNARVIM_CACHE_DIR/packer.nvim.log<cr>", "Open the Packer logfile" },
      },
      n = { "<cmd>Telescope notify<cr>", "View Notifications" },
      r = { "<cmd>IDEReload<cr>", "Reload LunarVim's configuration" },
      u = { "<cmd>LvimUpdate<cr>", "Update LunarVim" },
    },
    s = {
      name = "Search",
      b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
      c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
      H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
      M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
      R = { "<cmd>Telescope registers<cr>", "Registers" },
      t = { "<cmd>Telescope live_grep<cr>", "Text" },
      k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
      C = { "<cmd>Telescope commands<cr>", "Commands" },
      p = {
        "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
        "Colorscheme with Preview",
      },
    },
    T = {
      name = "Treesitter",
      i = { ":TSConfigInfo<cr>", "Info" },
      p = { ":TSPlaygroundToggle<cr>", "Playground" },
    },
    r = {
      name = "React",
      s = { ":lua require('user.utils.react').select_closest_parent(false)<cr>", "Select Component"},
      i = { ":lua require('user.utils.react').select_closest_parent(true)<cr>", "Select Inner"},
      I = { ":lua require('user.utils.react').select_closest_parent(true, 2)<cr>", "Select Parental Inner"},
      S = { ":lua require('user.utils.react').select_closest_parent(false, 2)<cr>", "Select Parent"},
      c = { ":lua require('user.utils.react').toggle_react_comment(1)<cr>", "Comment Component"},
      C = { ":lua require('user.utils.react').toggle_react_comment(2)<cr>", "Comment Parent"}
    }
  },
}

return M
