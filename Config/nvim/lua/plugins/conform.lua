return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")

		conform.setup({
			format_on_save = {
				timeout_ms = 3000,
				lsp_fallback = true,
			},

			formatters = {
				pint_local = {
					command = "pint",
					stdin = false,
					cwd = function(self, ctx)
						return vim.fs.root(ctx.filename, { "artisan" })
					end,
					args = function(self, ctx)
						return { ctx.filename }
					end,
				},
			},

			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				vue = { "prettier" },
				sh = { "shfmt" },
				nix = { "nixfmt" },
				ejs = { "prettier" },
				go = { "go fmt" },
				php = function()
					local fname = vim.api.nvim_buf_get_name(0)
					local laravel_root = vim.fs.root(fname, { "artisan" })
					if laravel_root then
						return { "pint_local" }
					end
					return { "php-cs-fixer" }
				end,
				qml = { "qmlfmt" },
				rust = { "rustfmt" },
			},
		})
	end,
}
