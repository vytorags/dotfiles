return {
	"adalessa/laravel.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"tpope/vim-dotenv",
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		if vim.fn.filereadable("artisan") == 1 then
			local ok, laravel = pcall(require, "laravel")
			if ok then
				laravel.setup({
					lsp_server = "intelephense",
					features = {
						null_ls = { enabled = false },
						route_info = { enabled = false },
						model_info = { enabled = false },
						composer_info = { enabled = false },
					},
				})
			end
		end

		vim.keymap.set("n", "<leader>laa", ":Laravel artisan<cr>", { desc = "Laravel Artisan picker" })
		vim.keymap.set("n", "<leader>lar", ":Laravel routes<cr>", { desc = "Laravel Route list" })
		vim.keymap.set("n", "<leader>lam", ":Laravel related<cr>", { desc = "Laravel Model info" })
		vim.keymap.set("n", "<leader>lat", ":Laravel tinker<cr>", { desc = "Laravel Tinker" })
	end,
}
