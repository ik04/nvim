-- ~/.config/nvim/lua/plugins/lsp.lua (or wherever you manage LSP plugins)

return {
	-- ===========================================================================
	-- 1. LSP Installer: Mason
	--    (Ensures LSP servers, formatters, debuggers are installed)
	-- ===========================================================================
	{
		"williamboman/mason.nvim",
		cmd = "Mason", -- Lazy load via command to improve startup time
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
				-- Customize install directory, etc. if needed
				-- install_root_dir = vim.fn.stdpath("data") .. "/mason",
			})
		end,
	},

	-- ===========================================================================
	-- 2. LSP Integration: Mason-LSPConfig
	--    (Connects Mason's installed LSPs with nvim-lspconfig)
	-- ===========================================================================
	{
		"williamboman/mason-lspconfig.nvim",
		-- Dependencies: nvim-lspconfig for actual LSP client, cmp-nvim-lsp for completion capabilities
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason-lspconfig").setup({
				-- List of LSP servers to ensure Mason installs
				ensure_installed = {
					"lua_ls",
					"clangd",
					"cmake", -- For CMake language support
					"cssls",
					"html",
					"jsonls",
					"markdown_oxide", -- Modern Markdown LSP
					"pyright", -- Python LSP
					"ts_ls", -- TypeScript/JavaScript LSP
					"rust_analyzer", -- Rust LSP (if you do Rust development)
					"bashls", -- Bash script LSP
					"lemminx", -- XML LSP
					"tailwindcss", -- Tailwind CSS LSP
					-- Add any other language servers you need here
				},
				-- Automatically setup servers for nvim-lspconfig.
				-- This will automatically call lspconfig.SERVER_NAME.setup({}) for installed servers
				-- unless you explicitly setup them in nvim-lspconfig block.
				automatic_installation = true,
			})
		end,
	},

	-- ===========================================================================
	-- 3. LSP Client: nvim-lspconfig
	--    (Main plugin for configuring and interacting with LSP servers)
	-- ===========================================================================
	{
		"neovim/nvim-lspconfig",
		-- Load this plugin when a buffer is read or a new file is created,
		-- allowing LSP to attach to relevant filetypes.
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Optional: For pretty LSP kind icons (e.g., function, variable icons in completion)
			-- "onsails/lspkind-nvim",
			-- Optional: For showing signature help in a floating window (often integrated with cmp)
			-- "hrsh7th/nvim-cmp", -- Usually handled by your main completion plugin setup
		},
		config = function()
			local lspconfig = require("lspconfig")
			-- Get default capabilities for nvim-cmp integration
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- This 'on_attach' function is called when an LSP server attaches to a buffer.
			-- It's the place to define buffer-local keymaps for LSP features.
			local on_attach = function(client, bufnr)
				-- Set buffer-local options for better LSP integration
				vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"
				vim.opt.tagfunc = "v:lua.vim.lsp.tagfunc"

				-- Helper function to set buffer-local keymaps with descriptions
				local map = function(mode, lhs, rhs, desc)
					vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
				end

				-- Basic LSP keymaps (Normal mode)
				map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", "LSP: Show Hover Documentation")
				map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "LSP: Go to Definition")
				map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "LSP: Go to Declaration")
				map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", "LSP: Go to Implementation")
				map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", "LSP: Find References")
				map("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "LSP: Go to Type Definition")
				map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", "LSP: Rename Symbol")
				map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", "LSP: Code Action")
				map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "LSP: Type Definition")
				map("n", "<leader>ds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "LSP: Document Symbols")
				map("n", "<leader>ws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "LSP: Workspace Symbols")

				-- Workspace related commands (less common, but useful)
				map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "LSP: Add Workspace Folder")
				map(
					"n",
					"<leader>wr",
					"<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
					"LSP: Remove Workspace Folder"
				)
				map(
					"n",
					"<leader>wl",
					"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
					"LSP: List Workspace Folders"
				)

				-- Diagnostics navigation (Requires Neovim 0.8+)
				map(
					"n",
					"[d",
					"<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>",
					"LSP: Prev Error Diagnostic"
				)
				map(
					"n",
					"]d",
					"<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>",
					"LSP: Next Error Diagnostic"
				)
				map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", "LSP: Show Line Diagnostics")
				map(
					"n",
					"<leader>ld",
					"<cmd>lua vim.diagnostic.set_loclist()<CR>",
					"LSP: Set Location List from Diagnostics"
				)

				-- Auto commands for highlighting references when cursor is held
				-- and clearing when cursor moves
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd("CursorMoved", {
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})

				-- Configure specific clients if needed (e.g., for certain capabilities)
				-- if client.name == "tsserver" then
				--   client.server_capabilities.documentFormattingProvider = false -- Let conform.nvim handle formatting
				-- end
			end

			-- Setup specific LSP servers.
			-- Servers listed in mason-lspconfig's ensure_installed that are NOT
			-- explicitly setup here will use a default setup provided by mason-lspconfig.
			-- Only setup here if you need custom settings for a specific server.

			-- Lua Language Server (lua_ls)
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = { -- Specific settings for lua_ls
					Lua = {
						diagnostics = {
							globals = { "vim" }, -- Crucial for Neovim's 'vim' global variable
						},
						workspace = {
							checkThirdParty = false, -- Avoids checking external libraries if not needed
							-- You might want to enable this if you use large Lua frameworks
							-- library = { vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua" },
						},
						telemetry = { enable = false }, -- Disable sending telemetry
					},
				},
			})

			-- Example: Python (Pyright)
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				-- settings = {
				--   python = {
				--     analysis = {
				--       autoSearchPaths = true,
				--       useLibraryCodeForTypes = true,
				--       diagnosticMode = "workspace",
				--     },
				--   },
				-- },
			})

			-- Example: TypeScript/JavaScript (tsserver)
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				-- root_dir = lspconfig.util.root_pattern("package.json"), -- Example for custom root detection
			})

			-- You can loop through other servers if they share the same setup
			-- For servers that don't need custom settings beyond capabilities/on_attach,
			-- mason-lspconfig.nvim will automatically call their setup.
			-- However, if you prefer explicit control or want to add
			-- options like `root_dir` or `settings` for ALL of them, you'd add them here.
			local servers_to_setup_explicitly = {
				"clangd",
				"cssls",
				"html",
				"jsonls",
				-- "cmake", -- if mason-lspconfig default isn't enough
			}

			for _, server in ipairs(servers_to_setup_explicitly) do
				lspconfig[server].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					-- You can add server-specific settings here for each one
					-- Example for clangd:
					-- cmd = {
					--   "clangd",
					--   "--background-index",
					--   "--clang-tidy",
					--   "--all-scopes-completion",
					--   "--header-insertion=never",
					-- },
				})
			end
		end,
	},
}
