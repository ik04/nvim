return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false, -- <--- CRITICAL for it to load on startup
	priority = 1000, -- Helps ensure it loads early
	config = function()
		require("rose-pine").setup({
			variant = "moon", -- Or "main" | "dawn"
			dark_variant = "moon",
			-- ... other rose-pine settings you want ...
		})
		vim.cmd("colorscheme rose-pine") -- <--- This applies it
	end,
}
