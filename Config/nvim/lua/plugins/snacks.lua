return {
  "folke/snacks.nvim",
  config = function() 
require("snacks").setup({
	dashboard = {
		enabled = true,
		preset = {
			header = [[
     ██╗ ██████╗ ██╗   ██╗██████╗  ██████╗ ██╗   ██╗
     ██║██╔═══██╗╚██╗ ██╔╝██╔══██╗██╔═══██╗╚██╗ ██╔╝
     ██║██║   ██║ ╚████╔╝ ██████╔╝██║   ██║ ╚████╔╝ 
██   ██║██║   ██║  ╚██╔╝  ██╔══██╗██║   ██║  ╚██╔╝  
╚█████╔╝╚██████╔╝   ██║   ██████╔╝╚██████╔╝   ██║   
 ╚════╝  ╚═════╝    ╚═╝   ╚═════╝  ╚═════╝    ╚═╝   
        ]],
			keys = {
				{ icon = "󰈞 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('smart')" },
				-- { icon = ' ', key = 'e', desc = 'New File', action = ':ene | startinsert' },
				-- {
				--   icon = ' ',
				--   key = 'g',
				--   desc = 'Find Text',
				--   action = ":lua Snacks.dashboard.pick('live_grep')",
				-- },
				{
					function()
						if require("nixCatsUtils").isNixCats == true then
							return {
								icon = " ",
								key = "c",
								desc = "NixDots Folder",
								action = ":tcd $HOME/nixdots/ | :e .",
							}
						else
							return {}
						end
					end,
				},
				{
					icon = " ",
					key = "r",
					desc = "Recent Files",
					action = ":lua Snacks.dashboard.pick('oldfiles')",
				},
				{
					icon = " ",
					key = "p",
					desc = "Project Folder",
					action = ":tcd $HOME/Workspace/Projects/ | :e .",
				},
				{
					function()
						if require("nixCatsUtils").isNixCats == true then
							return {}
						else
							return { icon = " ", key = "s", desc = "Settings", action = ":e $MYVIMRC | :tcd %:p:h" }
						end
					end,
				},
				{
					icon = "󰒲 ",
					key = "L",
					desc = "Lazy",
					action = ":Lazy",
					enabled = package.loaded.lazy ~= nil,
				},
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		-- formats = {
		--   key = function(item)
		--     return { { '[', hl = 'special' }, { item.key, hl = 'key' }, { ']', hl = 'special' } }
		--   end,
		-- },
		sections = {
			{ section = "header" },
			-- { section = 'terminal', cmd = 'cowsay -t "JOYBOY"', hl = 'header', padding = 1, indent = 4 },
			{ section = "keys", padding = 2, gap = 0 },
		},
	},
	indent = {
		priority = 1,
		enabled = true,
		indent = {
			hl = {
				"SnacksIndent1",
				"SnacksIndent2",
				"SnacksIndent3",
				"SnacksIndent4",
				"SnacksIndent5",
				"SnacksIndent6",
				"SnacksIndent7",
				"SnacksIndent8",
			},
		},
		scope = {
			enabled = true,
			priority = 200,
			underline = false,
			only_current = false,
			hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
		},
	},
	statuscolumn = {
		enabled = true,
		left = { --[[ "mark", "sign" ]]
		},
		right = { "fold", "git" },
		folds = {
			open = true,
			git_hl = true,
		},
		git = {
			patterns = { "GitSign", "MiniDiffSign" },
		},
		refresh = 50,
	},
	terminal = { enabled = true },
	input = { enabled = true },
	explorer = {
		enabled = true,
		replace_netrw = true,
		tree = true,
		follow_file = true,
	},
	picker = {
		enabled = true,
		ui_select = true,
		layout = {
			layout = {
				preset = "vscode",
				backdrop = false,
			},
		},
		sources = {
			files = {
				ignored = true,
				exclude = {
					"**/.DS_Store",
					"**/node_modules/**",
					"**/.vscode",
				},
				include = {
					".env",
					".direnv",
					".envrc",
					"Dockerfile",
					"docker-compose.yml",
				},
			},
			explorer = {
				replace_netrw = true,
				tree = true,
				follow_file = true,
				focus = "list",
				watch = true,
				diagnostics = false,
				diagnostics_open = false,
				git_status = true,
				git_status_open = false,
				git_untracked = true,
				exclude = {
					".DS_Store",
					"node_modules",
					".vscode",
					".git",
				},
				include = {
					".env",
					".direnv",
					".envrc",
					"Dockerfile",
					"docker-compose.yml",
					"tests/",
				},
				layout = {
					preset = "sidebar",
					layout = {
						position = "right",
						box = "vertical",
					},
					preview = false,
				},
			},
		},
	},
	image = { enabled = false },
	notifier = { enabled = true },
	quickfile = { enabled = false },
	scope = { enabled = true },
	scroll = { enabled = true },
	words = { enabled = false },
	bigfile = { enabled = false },
	git = { enabled = true },
	gitbrowser = { enabled = true },
	zen = { enabled = false },
	styles = {
		input = {
			backdrop = false,
			position = "float",
			border = "rounded",
			title_pos = "center",
			height = 1,
			width = 60,
			relative = "editor",
			noautocmd = true,
			row = 2,
			wo = {
				winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
				cursorline = false,
			},
			bo = {
				filetype = "snacks_input",
				buftype = "prompt",
			},
			b = {
				completion = false,
			},
			blame_line = {
				width = 0.6,
				height = 0.6,
				border = "rounded",
				title = " Git Blame ",
				title_pos = "center",
				ft = "git",
			},
			keys = {
				n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
				i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
				i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = { "i", "n" }, expr = true },
				i_tab = { "<tab>", { "cmp_select_next", "cmp" }, mode = "i", expr = true },
				i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
				i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
				i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
				q = "cancel",
			},
		},

		float = {
			position = "float",
			backdrop = 60,
			height = 0.9,
			width = 0.9,
			zindex = 50,
		},

		zoom_indicator = {
			text = "▍ zoom  󰊓  ",
			minimal = true,
			enter = false,
			focusable = false,
			height = 1,
			row = 0,
			col = -1,
			backdrop = false,
		},

		help = {
			position = "float",
			backdrop = false,
			border = "top",
			row = -1,
			width = 0,
			height = 0.3,
		},
	},
})

local snacks_keys = {
	{
		"<leader>e",
		function()
			local explorer_pickers = Snacks.picker.get({ source = "explorer" })
			for _, v in pairs(explorer_pickers) do
				if v:is_focused() then
					v:close()
				else
					v:focus()
				end
			end
			if #explorer_pickers == 0 then
				Snacks.picker.explorer()
			end
		end,
		desc = "Open Explorer",
	},
	{
		"<leader>f",
		function()
			Snacks.picker.smart()
		end,
		desc = "Smart Find Files",
	},
	{
		"<leader>b",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Buffers",
	},
	{
		"<leader>/",
		function()
			Snacks.picker.grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>:",
		function()
			Snacks.picker.command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>n",
		function()
			Snacks.picker.notifications()
		end,
		desc = "Notification History",
	},
	{
		"<leader>v",
		function()
			Snacks.terminal()
		end,
		desc = "Open terminal",
	},
	{
		"<leader>g",
		function()
			Snacks.lazygit()
		end,
		desc = "Open lazygit in terminal",
	},
}

for _, key in ipairs(snacks_keys) do
	vim.keymap.set("n", key[1], key[2], { desc = key.desc, noremap = true, silent = true })
end
  end
}
