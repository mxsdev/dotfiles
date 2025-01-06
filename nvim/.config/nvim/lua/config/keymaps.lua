-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del("n", "<leader>fn")
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<leader>w")
vim.keymap.del("n", "<leader>wd")
vim.keymap.del("n", "<leader>wm")
vim.keymap.del("n", "<leader>L")
vim.keymap.del("n", "<c-/>")

-- map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
local defaults = {
  all_mode = {
    ["<up>"] = "<nop>",
    ["<left>"] = "<nop>",
    ["<right>"] = "<nop>",
    ["<down>"] = "<nop>",
  },

  insert_mode = {
    ["<A-Backspace>"] = "<Esc><Right>dbi",
    ["<C-Backspace>"] = "<Esc><Right>dbi",

    -- cursor navigation
    ["<C-h>"] = "<left>",
    ["<C-l>"] = "<right>",
    -- ["<C-j>"] = "<down>",
    -- ["<C-k>"] = "<up>",

    ["<S-Enter>"] = "<ESC>O",
  },

  normal_mode = {
    -- [">"] = ">>",
    -- ["<"] = "<<",

    -- Add New Line
    ["<Enter>"] = "o<ESC>",
    ["<S-Enter>"] = "O<ESC>",

    ["<leader>h"] = { "<cmd>nohlsearch<CR>", { desc = "Clear Search" } },
    ["<leader>Wd"] = { "<C-W>c", { desc = "Delete Window" } },

    ["<leader>w"] = { "<cmd>w<cr><esc>", { desc = "Save File" } },

    ["<leader>Ta"] = { "<cmd>e ~/.config/alacritty/alacritty.toml<cr>", { desc = "Configure Alacritty" } },
    ["<leader>Tg"] = { "<cmd>e ~/.config/ghostty/config<cr>", { desc = "Configure Ghostty" } },

    ["<leader>L"] = {
      ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})<cr>",
      { desc = "Configure LazyVim" },
    },

    ["<leader>bc"] = { "<cmd>:bd<cr>", { desc = "Close Buffer" } },

    -- map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
    ["<leader>tt"] = {
      function()
        Snacks.terminal()
      end,
      { desc = "Terminal (cwd)" },
    },

    ["<C-/>"] = {
      function()
        require("toggleterm").toggle(nil, nil, LazyVim.root(), "float")
      end,
      { desc = "Toggle Floating Terminal" },
    },
  },

  visual_mode = {},

  visual_block_mode = {},

  command_mode = {
    ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
    ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },

    -- ["<C-l>"] = { "<cr>" },
  },
}

for _, mode in pairs({ "visual_mode", "visual_block_mode" }) do
  defaults[mode] = vim.tbl_extend("error", defaults[mode], {
    p = '"_p',
  })
end

for _, mode in pairs({ "normal_mode", "visual_mode", "visual_block_mode" }) do
  defaults[mode] = vim.tbl_extend("error", defaults[mode], {
    -- Disable copy on clear
    ["c"] = '"_c',

    -- Disable copy on cut
    ["x"] = '"_x',
  })
end

-- Logic for remapping below...

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
  operator_mode = "o",
  all_mode = "",
}

for mode, mapping in pairs(defaults) do
  mode = mode_adapters[mode] or mode
  for key, val in pairs(mapping) do
    local opt = generic_opts[mode] or generic_opts_any
    if type(val) == "table" then
      opt = val[2]
      val = val[1]
    end
    if val then
      vim.keymap.set(mode, key, val, opt)
    else
      pcall(vim.api.nvim_del_keymap, mode, key)
    end
  end
end
