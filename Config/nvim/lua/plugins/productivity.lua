return {
	"folke/zen-mode.nvim",
	dependencies = {
		"hedyhli/outline.nvim",
		"HakonHarnes/img-clip.nvim",
	},
	config = function()
		require("zen-mode").setup({
			plugins = {
				twilight = { enabled = true },
			},
		})

		require("outline").setup({})
		require("img-clip").setup({})

		vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle Zen Mode" })
		vim.keymap.set("n", "<leader>o", "<cmd>Outline<cr>", { desc = "Toggle Outline" })
		vim.keymap.set("n", "<leader>p", "<cmd>PasteImage<cr>", { desc = "Paste image from clipboard" })
	end,
}
