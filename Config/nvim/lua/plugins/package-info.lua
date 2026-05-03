return {
	"vuki656/package-info.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("package-info").setup({})

		vim.keymap.set("n", "<leader>nps", function()
			require("package-info").show()
		end, { desc = "Show package versions" })

		vim.keymap.set("n", "<leader>npu", function()
			require("package-info").update()
		end, { desc = "Update package" })

		vim.keymap.set("n", "<leader>npd", function()
			require("package-info").delete()
		end, { desc = "Delete package" })

		vim.keymap.set("n", "<leader>npi", function()
			require("package-info").install()
		end, { desc = "Install new package" })
	end,
}
