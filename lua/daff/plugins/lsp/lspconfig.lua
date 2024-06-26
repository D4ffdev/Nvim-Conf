return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		--Import Lsp
		local lspconfig = require("lspconfig")
		--Import Cmp
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		--keymap
		local keymap = vim.keymap

		-- Opts
		local opts = { noremap = true, silent = true }
		local on_attach = function(client, bufnr)
			opts.buffer = bufnr

			--Set KeyBind
			opts.desc = "Show Lsp References"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

			opts.desc = "Go to Declaration"
			keymap.set("n", "gD", "vim.lsp.buf.declaration", opts)

			opts.desc = "See Lsp Definition"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

			opts.desc = "Go to Implementation"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

			opts.desc = "Go to Type Definition"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

			opts.desc = "Show buffer diagnostics"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		end

		-- Enable autocompletions
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Lua LSP
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- LSP Configs servers

		-- html lps
		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- Astro lsp
		lspconfig["astro"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "astro" },
		})

		-- tsserver lsp
		lspconfig["tsserver"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- Eslint lsp
		lspconfig["eslint"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- tailwindcss lsp
		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- css lsp
		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- json lsp
		lspconfig["jsonls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- bash lsp
		lspconfig["bashls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- rust_analyzer lsp
		lspconfig["rust_analyzer"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "rust" },
			root_dir = lspconfig.util.root_pattern("Cargo.toml"),
			settings = {
				diagnostics = {
					update_in_insert = true,
				},
				cargo = {
					allFeatures = true,
				},
			},
		})

		-- pyright lsp
		lspconfig["pyright"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- clangd lsp
		lspconfig["clangd"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "h", "c", "cpp", "cc", "objc", "objcpp" },
			cmd = { "clangd", "--background-index" },
			single_file_support = true,
			root_dir = lspconfig.util.root_pattern(
				".clangd",
				".clang-tidy",
				".clang-format",
				"compile_commands.json",
				"compile_flags.txt",
				"configure.ac",
				".git"
			),
		})

		-- PHP
		lspconfig["intelephense"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "php" },
			cmd = { "intelephense", "--stdio" },
			root_dir = lspconfig.util.root_pattern(
				"composer.json",
				"package.json",
				"Makefile",
				"phpstan.neon",
				"psalm.xml",
				"psalm.xml.dist"
			),
			settings = {
				intelephense = {
					files = {
						maxSize = 5000000,
					},
				},
			},
		})
		-- Change Diagnostic Signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
	end,
}
