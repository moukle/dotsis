-- put this in your main init.lua file ( before lazy setup )
require("custom.core")
require("custom.map")
require("custom.autocmd")

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Configure and install plugins
require("lazy").setup("custom.plugins", {
	change_detection = { notify = false },
})

-- vim: ts=2 sts=2 sw=2 et
