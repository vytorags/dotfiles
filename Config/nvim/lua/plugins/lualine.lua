return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		local lualine = require("lualine")

		local cp = require("catppuccin.palettes").get_palette("mocha")

		local colors = {
			a_bg = cp.mauve,
			a_fg = cp.crust,
			b_bg = cp.surface1,
			b_fg = cp.text,
			c_bg = cp.base,
			c_fg = cp.subtext1,
			x_bg = cp.base,
			x_fg = cp.subtext1,
			y_bg = cp.surface1,
			y_fg = cp.text,
			z_bg = cp.mauve,
			z_fg = cp.crust,
			icon = cp.overlay1,
		}

		local theme = {
			normal = {
				a = { bg = colors.a_bg, fg = colors.a_fg, gui = "bold" },
				b = { bg = colors.b_bg, fg = colors.b_fg },
				c = { bg = colors.c_bg, fg = colors.c_fg },
			},
			insert = { a = { bg = cp.green, fg = cp.crust, gui = "bold" } },
			visual = { a = { bg = cp.flamingo, fg = cp.crust, gui = "bold" } },
			replace = { a = { bg = cp.red, fg = cp.crust, gui = "bold" } },
			command = { a = { bg = cp.peach, fg = cp.crust, gui = "bold" } },
			inactive = {
				a = { bg = colors.c_bg, fg = colors.icon },
				b = { bg = colors.c_bg, fg = colors.icon },
				c = { bg = colors.c_bg, fg = colors.icon },
			},
		}

		local function lsp_status()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return "[SYSTEM:OFFLINE]"
			end
			local names = {}
			for _, client in ipairs(clients) do
				table.insert(names, string.upper(client.name))
			end
			return "[SYS:" .. table.concat(names, ",") .. "]"
		end

		vim.api.nvim_set_hl(0, "LualineIcon", { bg = cp.flamingo, fg = colors.icon })
		vim.api.nvim_set_hl(0, "LualineIcon2", { bg = cp.green, fg = colors.icon })

		lualine.setup({
			options = {
				icons_enabled = true,
				theme = theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				refresh = { statusline = 100, tabline = 100, winbar = 100 },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return "󰣚 " .. str:upper()
						end,
						separator = { right = "" },
					},
				},
				lualine_b = {
					{ "branch", icon = "" },
					{ lsp_status, color = { gui = "bold" } },
				},
				lualine_c = {
					{
						function()
							return "PATH:"
						end,
						color = { fg = "#585b70" },
						padding = { left = 1, right = 0 },
					},
					{ "filename", path = 1, symbols = { modified = "󰶐", readonly = "" } },
				},
				lualine_x = {
					{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " } },
				},
				lualine_y = {
					{ "encoding", fmt = string.upper },
					{ "progress", icon = "" },
				},
				lualine_z = {
					{ "location", icon = "", separator = { left = "" } },
				},
			},
			tabline = {},
			extensions = { "neo-tree", "quickfix", "fugitive" },
		})
	end,
}
