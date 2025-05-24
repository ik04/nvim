return {
	"catppuccin/nvim",
	lazy = true,
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
			flavour = "macchiato",
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
