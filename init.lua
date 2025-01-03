vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Keybinding to exit insert mode with 'jk'
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })

require("lazy").setup("plugins")
require("vim-options")

