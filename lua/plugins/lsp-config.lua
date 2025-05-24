return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp"
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "clangd", "cmake", "cssls", "html" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                local map = function(mode, lhs, rhs)
                    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true })
                end

                map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
                map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
                map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
                map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
                map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
            end

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        },
                        workspace = {
                            checkThirdParty = false
                        }
                    }
                }
            })

            local servers = { "clangd", "cmake", "cssls", "html" }
            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end
        end
    },
 -- --- NEW PLUGIN: CONFORM.NVIM FOR FORMATTING ---
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" }, -- Load on buffer write, optimizing startup
        cmd = { "ConformInfo" },   -- Allow manual triggering of ConformInfo
        keys = {                   -- Optional: Keybinding for manual formatting
            {
                "<leader>fm",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "", -- Applies to normal, visual, and select modes
                desc = "Format file",
            },
        },
        opts = {
            -- Define your formatters and their order of preference for each filetype
            formatters_by_ft = {
                lua = { "stylua" },
                -- For C/C++/CMake, use clang-format
                c = { "clang-format" },
                cpp = { "clang-format" },
                cmake = { "cmake_format" }, -- Or just "clang-format" if it handles cmake
                css = { { "prettierd", "prettier" } }, -- Try prettierd first, then prettier
                html = { { "prettierd", "prettier" } },
                -- Add other filetypes you use and their formatters
                -- javascript = { { "prettierd", "prettier" } },
                -- typescript = { { "prettierd", "prettier" } },
                -- json = { { "prettierd", "prettier" } },
                -- markdown = { { "prettierd", "prettier" } },
                -- python = { "black", "isort" },
            },
            -- Enable auto-formatting on save
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true, -- Fallback to LSP formatting if no conform formatter is found
            },
            -- You can also add more advanced options like logging, custom formatters etc.
            -- log_level = vim.log.levels.DEBUG,
            -- formatters = {
            --   some_custom_formatter = {
            --     command = "my-cli-tool",
            --     args = { "--some-arg", "$FILE" },
            --   },
            -- },
        },
    },
}



