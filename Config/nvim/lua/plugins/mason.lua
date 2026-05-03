return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"pyright",
				"html",
				"cssls",
				"emmet_ls",
				"lua_ls",
				"gopls",
				"bashls",
				"vtsls",
				"vue_ls",
				"dockerls",
				"docker_compose_language_service",
				"marksman",
				"qmlls",
				"intelephense",
				"rust_analyzer",
				"jdtls",
			},
			automatic_installation = false,
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"black",
				"shfmt",
				"php-cs-fixer",
				"pint",
			},
			auto_update = false,
			run_on_start = false,
		})
	end,
}
