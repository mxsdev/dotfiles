local M = {}
local Log = require "user.log"
local AU = require "user.core.autocmds"
local utils = require "user.utils"

function M.config()
  userconf.builtin.nvimtree = {
    active = true,
    on_config_done = nil,
    setup = {
      disable_netrw = true,
      hijack_netrw = true,
      -- open_on_setup = false,
      -- open_on_setup_file = false,
      sort_by = "name",
      -- ignore_buffer_on_setup = false,
      -- ignore_ft_on_setup = {
      --   "startify",
      --   "dashboard",
      --   "alpha",
      -- },
      auto_reload_on_write = true,
      hijack_unnamed_buffer_when_opening = false,
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      open_on_tab = false,
      hijack_cursor = false,
      update_cwd = false,
      diagnostics = {
        enable = userconf.use_icons,
        show_on_dirs = false,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
      },
      system_open = {
        cmd = nil,
        args = {},
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 200,
      },
      view = {
        width = 30,
        -- height = 30,
        hide_root_folder = false,
        side = "right",
        preserve_window_proportions = true,
        -- mappings = {
        --   custom_only = false,
        --   list = {},
        -- },
        number = true,
        relativenumber = true,
        signcolumn = "yes",
      },
      renderer = {
        indent_markers = {
          enable = false,
          icons = {
            corner = "└ ",
            edge = "│ ",
            none = "  ",
          },
        },
        icons = {
          webdev_colors = userconf.use_icons,
          show = {
            git = userconf.use_icons,
            folder = userconf.use_icons,
            file = userconf.use_icons,
            folder_arrow = userconf.use_icons,
          },
          glyphs = {
            default = "",
            symlink = "",
            git = {
              unstaged = "",
              staged = "S",
              unmerged = "",
              renamed = "➜",
              deleted = "",
              untracked = "U",
              ignored = "◌",
            },
            folder = {
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
            },
          },
        },
        highlight_git = true,
        root_folder_modifier = ":t",
      },
      filters = {
        dotfiles = false,
        custom = { "node_modules", "\\.cache" },
        exclude = {},
      },
      trash = {
        cmd = "trash",
        require_confirm = true,
      },
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          diagnostics = false,
          git = false,
          profile = false,
        },
      },
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        open_file = {
          quit_on_open = true,
          resize_window = true,
          window_picker = {
            enable = true,
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
      },
    },
  }
end

function M.setup()
  local status_ok, nvim_tree = pcall(require, "nvim-tree")
  if not status_ok then
    Log:error "Failed to load nvim-tree"
    return
  end

  if userconf.builtin.nvimtree._setup_called then
    Log:debug "ignoring repeated setup call for nvim-tree, see kyazdani42/nvim-tree.lua#1308"
    return
  end

  userconf.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" }
  userconf.builtin.nvimtree._setup_called = true

  -- Implicitly update nvim-tree when project module is active
  if userconf.builtin.project and userconf.builtin.project.active then
    userconf.builtin.nvimtree.setup.respect_buf_cwd = true
    userconf.builtin.nvimtree.setup.update_cwd = true
    userconf.builtin.nvimtree.setup.update_focused_file = { enable = true, update_cwd = true }
  end

  local function telescope_find_files(_)
    require("userconf.core.nvimtree").start_telescope "find_files"
  end

  local function telescope_live_grep(_)
    require("userconf.core.nvimtree").start_telescope "live_grep"
  end

  -- local mappings = {
  --   { key = { "l", "<CR>", "o" }, action = "edit",                 mode = "n" },
  --   { key = "h",                  action = "close_node" },
  --   { key = "v",                  action = "vsplit" },
  --   { key = "C",                  action = "cd" },
  --   { key = "gtf",                action = "telescope_find_files", action_cb = telescope_find_files },
  --   { key = "gtg",                action = "telescope_live_grep",  action_cb = telescope_live_grep },
  --   { key = "<C-s>",              action = "<Plug>Telescope_s" },
  --   { key = "d",                  action = "trash" },
  --   { key = "D",                  action = "remove" }
  -- }

  local function on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))

    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))

    vim.keymap.set("n", "v", api.node.open.vertical, opts("Open V-Split"))

    vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("CD"))

    vim.keymap.set("n", "gtf", telescope_find_files, opts("Telescope Find Files"))
    vim.keymap.set("n", "gtg", telescope_live_grep, opts("Telescope Live Grep"))

    -- vim.keymap.set("n", "<C-s>", telescope_find_files, opts("Telescope Find Files"))

    vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))
    vim.keymap.set("n", "D", api.fs.remove, opts("Remove"))
  end

  userconf.builtin.nvimtree.setup.on_attach = on_attach

  nvim_tree.setup(userconf.builtin.nvimtree.setup)

  if userconf.builtin.nvimtree.on_config_done then
    userconf.builtin.nvimtree.on_config_done(nvim_tree)
  end

  local resize = function(winnr, bufnr)
    local w = require("user.utils.buffer").buffer_max_line(bufnr)
    vim.api.nvim_win_set_width(winnr, w + 5)
  end

  local view = require("nvim-tree.view")

  local api = require("nvim-tree.api")
  local Event = api.events.Event

  api.events.subscribe(Event.FileCreated, function(data)
    local fname = data.new_name
    utils.edit(fname)
  end)

  api.events.subscribe(Event.TreeOpen, function()
    local winnr = view.get_winnr()
    local bufnr = view.get_bufnr()

    vim.api.nvim_buf_attach(bufnr, true, {
      on_lines = function(lines)
        resize(winnr, bufnr)
      end
    })
  end)
end

function M.start_telescope(telescope_mode)
  local node = require("nvim-tree.lib").get_node_at_cursor()
  local abspath = node.link_to or node.absolute_path
  local is_folder = node.open ~= nil
  local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
  require("telescope.builtin")[telescope_mode] {
    cwd = basedir,
  }
end

return M
