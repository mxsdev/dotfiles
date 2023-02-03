-- DONT REINCLUDE
-- require('impatient').enable_profile()

require"user.plugins"

require("user.config"):init()
require("user.utils").setup()

-- require"user.plugins"
require"user.colorscheme"

-- DONT REINCLUDE
-- require"user.autocommands"

require("user.lsp").setup()
require"user.core"
require"user.syntax"
require"user.docs"
require"user.dap".setup()
