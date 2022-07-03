require('impatient').enable_profile()

require("user.config"):init()
require("user.utils").setup()

require"user.plugins"
require"user.colorscheme"
-- require"user.autocommands"

require("user.lsp").setup()
require"user.core"
require"user.syntax"
require"user.docs"
require"user.dap".setup()
