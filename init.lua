-- init.lua

vim.opt.clipboard = "unnamedplus"

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

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })

-- 1. Ctrl+C for Copy to System Clipboard (in Visual Mode)
-- When text is selected visually, Ctrl+C will yank it to the system clipboard.
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })

-- 2. Ctrl+V for Paste from System Clipboard (in Normal Mode)
-- Pastes content from the system clipboard after the cursor.
vim.api.nvim_set_keymap("n", "<C-v>", '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })

-- 3. Ctrl+V for Paste from System Clipboard (in Insert Mode)
-- This makes Ctrl+V behave more like a standard text editor:
-- <ESC>    : Exit insert mode temporarily
-- "+p     : Paste from the system clipboard
-- i        : Re-enter insert mode immediately after pasting
vim.api.nvim_set_keymap(
	"i",
	"<C-v>",
	'<ESC>"+pi',
	{ noremap = true, silent = true, desc = "Paste from system clipboard (Insert Mode)" }
)

-- 4. Ctrl+V for Paste from System Clipboard (in Visual Mode)
-- Replaces the selected text with content from the system clipboard.
vim.api.nvim_set_keymap(
	"v",
	"<C-v>",
	'"+p',
	{ noremap = true, silent = true, desc = "Paste from system clipboard (Visual Mode)" }
)

require("lazy").setup("plugins")
require("vim-options")
