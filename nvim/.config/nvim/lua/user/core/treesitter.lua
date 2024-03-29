local Log = require "user.log"

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  Log:warn("Unable to load nvim-treesitter.configs")
  return
end

configs.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "elm", "embedded_template", "fortran", "hack", "haskell", "org", "phpdoc", "swift" }, -- List of parsers to ignore installing
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = false, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  --[[ rainbow = { ]]
  --[[   enable = true, ]]
  --[[   extended_mode = true, ]]
  --[[   max_file_lines = nil, ]]
  --[[ }, ]]
}
