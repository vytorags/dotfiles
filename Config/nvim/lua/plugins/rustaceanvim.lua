return {
	"mrcjkb/rustaceanvim",
	config = function()
		if require("nixCatsUtils").isNixCats then
			vim.g.rustaceanvim = {
				server = {
					auto_attach = false,
				},
			}
		end

		vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", { desc = "RustLsp runnables" })
		vim.keymap.set("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>", { desc = "RustLsp debuggables" })
		vim.keymap.set("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>", { desc = "RustLsp expandMacro" })
		vim.keymap.set("n", "<leader>rc", "<cmd>RustLsp openCargo<cr>", { desc = "RustLsp openCargo" })
		vim.keymap.set("n", "<leader>rh", "<cmd>RustLsp hover actions<cr>", { desc = "RustLsp hover actions" })
	end,
}
