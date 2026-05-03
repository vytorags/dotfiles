return {
	"nvim-java/nvim-java",
	config = function()
		if not require("nixCatsUtils").isNixCats then
			require("java").setup()
		end

		vim.keymap.set("n", "<leader>jt", "<cmd>JavaTestRunCurrentClass<cr>", { desc = "JavaTestRunCurrentClass" })
		vim.keymap.set("n", "<leader>jd", "<cmd>JavaTestDebugCurrentClass<cr>", { desc = "JavaTestDebugCurrentClass" })
		vim.keymap.set("n", "<leader>jb", "<cmd>JavaBuild<cr>", { desc = "Java build" })
		vim.keymap.set("n", "<leader>jr", "<cmd>JavaRunMain<cr>", { desc = "Java run main" })
	end,
}
