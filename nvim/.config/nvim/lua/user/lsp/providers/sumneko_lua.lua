local opts = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "userconf", "packer_plugins" },
        disable = { "different-requires" },
      },
      workspace = {
        library = {
          [require("user.utils").join_paths(get_runtime_dir(), "user", "lua")] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      runtime = {
        version = "Lua 5.4",
      },
    },
  },
}

local lua_dev_loaded, lua_dev = pcall(require, "lua-dev")
if not lua_dev_loaded then
  return opts
end

local dev_opts = {
  library = {
    vimruntime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    -- plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    plugins = { "plenary.nvim" },
  },
  lspconfig = opts,
}

return lua_dev.setup(dev_opts)
