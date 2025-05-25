return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8", -- It's generally good to pin versions
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim", -- ui-select is a dependency for its features
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			-- Telescope Setup (Optional but recommended for customization)
			telescope.setup({
				defaults = {
					sorting_strategy = "ascending",
					-- Use ui-select for some pickers
					file_sorter = require("telescope.sorters").get_fuzzy_file_sorter,
					generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- You can customize ui-select theme options here
							-- border = "none",
							-- winblend = 20,
						}),
					},
				},
			})

			-- Load extensions (important for ui-select to work)
			telescope.load_extension("ui-select")

			-- Keymaps for Telescope
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })

			-- Keymap for Buffer Switching
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
			-- Or if you prefer a different keymap, e.g., just "<leader>b":
			-- vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Find Buffers" })

			-- Optional: More useful Telescope pickers
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Old Files" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files (Alt)" }) -- Redundant if <C-p> is enough
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep Word Under Cursor" })
			vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "Telescope Builtin Pickers" }) -- Shows all Telescope pickers
		end,
	},
}
