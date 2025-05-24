return {
	"catppuccin/nvim",
	lazy = true,
	name = "catppuccin",
	priority = 2000,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
