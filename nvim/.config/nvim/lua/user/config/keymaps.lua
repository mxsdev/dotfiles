local M = {}
local Log = require "user.log"
local tsurfer = require"user.syntax.tree-surfer"

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
  all_mode = ""
}

M.get_mode = function(mode)
  return mode_adapters[mode] or mode
end

---@class Keys
---@field insert_mode table
---@field normal_mode table
---@field terminal_mode table
---@field visual_mode table
---@field visual_block_mode table
---@field command_mode table

local defaults = {
  all_mode = {
    ["<up>"] = "<nop>",
    ["<left>"] = "<nop>",
    ["<right>"] = "<nop>",
    ["<down>"] = "<nop>",
  };
  insert_mode = {
    -- 'Ctrl+C' for quitting insert mode
    ["<C-c>"] = "<ESC>",
    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-j>"] = "<Esc>:m .+1<CR>==gi",
    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-k>"] = "<Esc>:m .-2<CR>==gi",
    -- navigation
    ["<A-Up>"] = "<C-\\><C-N><C-w>k",
    ["<A-Down>"] = "<C-\\><C-N><C-w>j",
    ["<A-Left>"] = "<C-\\><C-N><C-w>h",
    ["<A-Right>"] = "<C-\\><C-N><C-w>l",

    -- new lines
    ["<C-Enter>"] = "<C-o>o",
    ["<S-Enter>"] = "<C-o>O",

    -- cursor navigation
    ["<C-h>"] = "<left>",
    ["<C-l>"] = "<right>",
    ["<C-j>"] = "<down>",
    ["<C-k>"] = "<up>",

    -- horizontal navigation
    ["<C-r>"] = "<C-o>A",
    -- ["<C-s>"] = "<C-o>^",

    -- Lightspeed
    ["<C-s>"] = "<C-o><Plug>Lightspeed_s",
    ["<C-S>"] = "<C-o><Plug>Lightspeed_S",
  },

  normal_mode = {
    -- Better window movement
    ["<C-h>"] = "<C-w>h",
    ["<C-j>"] = "<C-w>j",
    ["<C-k>"] = "<C-w>k",
    ["<C-l>"] = "<C-w>l",

    -- Resize with arrows
    ["<C-Up>"] = ":resize -2<CR>",
    ["<C-Down>"] = ":resize +2<CR>",
    ["<C-Left>"] = ":vertical resize -2<CR>",
    ["<C-Right>"] = ":vertical resize +2<CR>",

    -- Tab switch buffer
    ["<S-l>"] = ":BufferLineCycleNext<CR>",
    ["<S-h>"] = ":BufferLineCyclePrev<CR>",

    -- Move current line / block with Alt-j/k a la vscode.
    ["<A-j>"] = ":m .+1<CR>==",
    ["<A-k>"] = ":m .-2<CR>==",

    -- QuickFix
    ["]q"] = ":cnext<CR>",
    ["[q"] = ":cprev<CR>",
    ["<C-q>"] = ":call QuickFixToggle()<CR>",

    -- Add New Line
    ["<Enter>"] = "o<ESC>",
    ["<S-Enter>"] = "O<ESC>",

    -- Select Pasted Text
    ["gp"] = "`[v`]",

    -- Syntax Tree Surfer
    ["vU"] = { tsurfer.swapUpMaster, { expr = true }},
    ["vD"] = { tsurfer.swapDownMaster, { expr = true }},
    ["vd"] = { tsurfer.swapDownCurrent, { expr = true}},
    ["vu"] = { tsurfer.swapUpCurrent, {expr = true}},
    ["vx"] = "<cmd>STSSelectMasterNode<cr>",
    ["vn"] = "<cmd>STSSelectCurrentNode<cr>"
  },

  term_mode = {
    -- Terminal window navigation
    ["<C-h>"] = "<C-\\><C-N><C-w>h",
    ["<C-j>"] = "<C-\\><C-N><C-w>j",
    ["<C-k>"] = "<C-\\><C-N><C-w>k",
    ["<C-l>"] = "<C-\\><C-N><C-w>l",
  },

  visual_mode = {
    -- Better indenting
    ["<"] = "<gv",
    [">"] = ">gv",

    -- ["p"] = '"0p',
    -- ["P"] = '"0P',
  },

  visual_block_mode = {
    -- Move selected line / block of text in visual mode
    ["K"] = ":move '<-2<CR>gv-gv",
    ["J"] = ":move '>+1<CR>gv-gv",

    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-j>"] = ":m '>+1<CR>gv-gv",
    ["<A-k>"] = ":m '<-2<CR>gv-gv",

    -- Syntax Tree Surfer
    ["<C-j>"] = '<cmd>STSSelectNextSiblingNode<cr>',
    ["<C-k>"] = '<cmd>STSSelectPrevSiblingNode<cr>',
    ["<C-h>"] = '<cmd>STSSelectParentNode<cr>',
    ["<C-l>"] = '<cmd>STSSelectChildNode<cr>',
    ["L"] = '<cmd>STSSwapNextVisual<cr>',
    ["H"] = '<cmd>STSSwapPrevVisual<cr>'
  },

  command_mode = {
    -- navigate tab completion with <c-j> and <c-k>
    -- runs conditionally
    ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
    ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
  },

  operator_mode = {

  },
}

-- for _, mode in pairs({ "normal_mode", "visual_mode", "visual_block_mode" }) do
--   -- defaults[mode]["<leader>"] = {"<Cmd>lua require('which-key').show(' ', {mode = 'v', auto = true})<CR>", { nowait = true }}
--   -- defaults[mode]["<leader>"] = {"<nop>", { noremap = true }}
--   -- vim.api.nvim_del_keymap(mode, "<leader>")
--   -- M.clear({ [mode] = { "<leader>"}})
--   pcall(vim.keymap.del, mode_adapters[mode], "<leader>")
-- end

local tsht_nodes_cmd = "lua require('tsht').nodes()<CR>"
local tsht_nodes_key = "m"

for _, mode in pairs({ "normal_mode", "visual_mode" }) do
  defaults[mode][tsht_nodes_key] = { ":" .. tsht_nodes_cmd, { noremap = true } }
end

defaults["operator_mode"][tsht_nodes_key] = { ":<C-U>" .. tsht_nodes_cmd }

if vim.fn.has "mac" == 1 then
  defaults.normal_mode["<A-Up>"] = defaults.normal_mode["<C-Up>"]
  defaults.normal_mode["<A-Down>"] = defaults.normal_mode["<C-Down>"]
  defaults.normal_mode["<A-Left>"] = defaults.normal_mode["<C-Left>"]
  defaults.normal_mode["<A-Right>"] = defaults.normal_mode["<C-Right>"]
  Log:debug "Activated mac keymappings"
end

-- Unsets all keybindings defined in keymaps
-- @param keymaps The table of key mappings containing a list per mode (normal_mode, insert_mode, ..)
function M.clear(keymaps)
  local default = M.get_defaults()
  for mode, mappings in pairs(keymaps) do
    local translated_mode = mode_adapters[mode] or mode
    for key, _ in pairs(mappings) do
      -- some plugins may override default bindings that the user hasn't manually overridden
      if default[mode][key] ~= nil or (default[translated_mode] ~= nil and default[translated_mode][key] ~= nil) then
        pcall(vim.keymap.del, translated_mode, key)
      end
    end
  end
end

-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
function M.set_keymaps(mode, key, val)
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

-- Load key mappings for a given mode
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param keymaps The list of key mappings
function M.load_mode(mode, keymaps)
  mode = mode_adapters[mode] or mode
  for k, v in pairs(keymaps) do
    M.set_keymaps(mode, k, v)
  end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
function M.load(keymaps)
  keymaps = keymaps or {}
  for mode, mapping in pairs(keymaps) do
    M.load_mode(mode, mapping)
  end
end

-- Load the default keymappings
function M.load_defaults()
  M.load(M.get_defaults())
  userconf.keys = userconf.keys or {}
  for idx, _ in pairs(defaults) do
    if not userconf.keys[idx] then
      userconf.keys[idx] = {}
    end
  end
end

-- Get the default keymappings
function M.get_defaults()
  return defaults
end

return M
