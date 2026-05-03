return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-jest",
		"rcasia/neotest-java",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-vitest"),
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "jest.config.js",
					env = { CI = true },
					cwd = function(_)
						return vim.fn.getcwd()
					end,
				}),
				require("neotest-java"),
			},
		})
	end,
}
