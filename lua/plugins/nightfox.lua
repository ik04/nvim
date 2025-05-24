return {
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nightfox").setup({
				-- Your customization options here (see next section)
			})

			-- Set the colorscheme. You can choose any of the variants.
			vim.cmd("colorscheme carbonfox") -- Or carbonfox, nordfox, etc.
		end,
	},
}
