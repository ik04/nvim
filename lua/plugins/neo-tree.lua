return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = true, -- Show hidden files
                    hide_dotfiles = false, -- Don't hide dotfiles (e.g., .gitignore)
                    hide_gitignored = false, -- Show files ignored by Git
                }
            }
        })
        vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
        vim.keymap.set('n', '<C-q>', ':Neotree close<CR>', {}) -- Keybind to close Neo-tree
    end
}

