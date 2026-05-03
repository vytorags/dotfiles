local options = {
	clipboard = "unnamedplus",
	mouse = "a",
	expandtab = false,
	shiftwidth = 4,
	tabstop = 4,
	cursorline = true,
	number = true,
	relativenumber = true,
	numberwidth = 4,
	termguicolors = true,
	wrap = false,
	smartindent = true,
	showmatch = true,
	completeopt = { "menuone", "noselect" },
	foldenable = true,
	foldmethod = "expr",
	foldexpr = "nvim_treesitter#foldexpr()",
	foldlevel = 99,
	signcolumn = "yes",
	fillchars = "eob: ",
	listchars = {
		space = "·",
		tab = "··",
		lead = "·",
		trail = "·",
		eol = "↴",
	},
	list = false,
	wildmenu = true,
	wildmode = "longest:full,full",
	backup = false,
	swapfile = false,
	incsearch = true,
	ignorecase = true,
	smartcase = true,
	scrolloff = 8,
	sidescrolloff = 8,
	hlsearch = true,
	updatetime = 100,
	timeoutlen = 200,
	redrawtime = 1500,
}
for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "jsonq", "json", "nix", "lua" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.ejs",
	command = "set filetype=html",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "make",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})
