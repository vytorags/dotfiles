require("nixCatsUtils").setup({
  non_nix_value = true,
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = nixCats("have_nerd_font")

require("config.options")
require("config.keymaps")
require("config.lazy")


-- local function getlockfilepath()
--   if require("nixCatsUtils").isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
--     return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
--   else
--     return vim.fn.stdpath("config") .. "/lazy-lock.json"
--   end
-- end

local nixCatsUtils = require("nixCatsUtils")
if not nixCatsUtils.isNixCats then
  require("plugins.mason")
end
