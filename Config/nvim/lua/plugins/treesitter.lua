return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"tree-sitter/tree-sitter-embedded-template",
	},
	lazy = false,
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.install({
			"c",
			"lua",
			"css",
			"html",
			"cpp",
			"javascript",
			"rust",
			"java",
			"sql",
			"nix",
			"markdown",
			"json",
			"yaml",
			"python",
			"go",
			"php",
			"vue",
		})

		treesitter.setup({
			sync_install = false,
			ignore_install = {},
			auto_install = require("nixCatsUtils").lazyAdd(true, false),

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				disable = function(lang, buf)
					local max_filesize = 500 * 1024
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},

			indent = {
				enable = true,
			},

			fold = {
				enable = true,
			},

			playground = {
				enable = false,
			},
			modules = {},
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
