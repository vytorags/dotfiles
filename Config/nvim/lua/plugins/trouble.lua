return {
	"folke/trouble.nvim",
	config = function()
		require("trouble").setup({})

		vim.keymap.set(
			"n",
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle win.type=float focus=true<cr>",
			{ desc = "Diagnostics (Trouble)" }
		)
		vim.keymap.set(
			"n",
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0 win.type=float focus=true<cr>",
			{ desc = "Buffer Diagnostics (Trouble)" }
		)
		vim.keymap.set(
			"n",
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false win.position=left<cr>",
			{ desc = "Symbols (Trouble)" }
		)
		vim.keymap.set(
			"n",
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=left<cr>",
			{ desc = "LSP Definitions / references / ... (Trouble)" }
		)
		vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
		vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
	end,
}
