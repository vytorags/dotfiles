return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	config = function()
		vim.keymap.set("n", "zR", function()
			require("ufo").openAllFolds()
		end, { desc = "Open all folds" })

		vim.keymap.set("n", "zM", function()
			require("ufo").closeAllFolds()
		end, { desc = "Close all folds" })

		vim.keymap.set("n", "zz", function()
			require("ufo").peekFoldedLinesUnderCursor()
		end, { desc = "Peek folded lines under cursor" })

		require("ufo").setup({
			open_fold_hl_timeout = 0,
			fold_virt_text_handler = function(text, lnum, end_lnum, width)
				local suffix = "  "
				local lines = ("(%d lines) "):format(end_lnum - lnum)

				local cur_width = 0
				for _, section in ipairs(text) do
					cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
				end

				suffix = suffix .. (" "):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 3)
				table.insert(text, { suffix, "Comment" })
				table.insert(text, { lines, "Todo" })
				return text
			end,
			preview = {
				win_config = {
					winblend = 0,
					winhighlight = "Normal:LazyNormal",
					border = "none",
				},
			},
		})
	end,
}
