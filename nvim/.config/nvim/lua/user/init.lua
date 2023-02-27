-- DONT REINCLUDE
-- require('impatient').enable_profile()

require("user.config"):init()
require("user.utils").setup()
require"user.plugins"

-- require"user.plugins"
require"user.colorscheme"

-- DONT REINCLUDE
-- require"user.autocommands"

require"user.core"
require("user.lsp").setup()
require"user.syntax"
require"user.docs"
require"user.dap".setup()
