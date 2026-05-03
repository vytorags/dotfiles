return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua",
	},
	config = function()
		require("go").setup({
			diagnostic = false,
			lsp_gofumpt = true,
			lsp_codelens = false,
		})

		vim.keymap.set("n", "<leader>got", "<cmd>GoTest<cr>", { desc = "GoTest (current func)" })
		vim.keymap.set("n", "<leader>goc", "<cmd>GoCoverage toggle<cr>", { desc = "GoCoverage toggle" })
		vim.keymap.set("n", "<leader>goi", "<cmd>GoImpl<cr>", { desc = "GoImpl" })
		vim.keymap.set("n", "<leader>gos", "<cmd>GoFillStruct<cr>", { desc = "GoFillStruct" })
		vim.keymap.set("n", "<leader>goT", "<cmd>GoAddTag<cr>", { desc = "GoAddTag" })
	end,
}
