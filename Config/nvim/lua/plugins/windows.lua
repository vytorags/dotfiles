return {
	"anuvyklack/windows.nvim",
	dependencies = {
		"anuvyklack/middleclass",
		"anuvyklack/animation.nvim",
	},
	config = function()
		vim.o.winwidth = 10
		vim.o.winminwidth = 10
		vim.o.equalalways = false

		require("windows").setup({
			ignore = {
				buftype = { "quickfix" },
				filetype = { "NvimTree", "neo-tree", "undotree", "gundo", "snacks_layout_box" },
			},
			animation = {
				enable = true,
				duration = 300,
				fps = 30,
				easing = "in_out_sine",
			},
		})
	end,
}
