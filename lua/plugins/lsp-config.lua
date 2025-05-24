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
    }
}

