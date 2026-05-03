---@diagnostic disable: missing-parameter
local opts = { noremap = true, silent = true }
local ui = require("util.ui")

local map = vim.keymap.set

map("n", "<C-a>", ":normal ggVG<CR>", opts)

map("n", "<C-c>", '"+y', opts)
map("v", "<C-c>", '"+y', opts)

map("n", "<C-s>", ":w<CR>", opts)
map("i", "<C-s>", "<C-o>:w<CR>", opts)

map("n", "<C-f>", ":%s/foo/bar", opts)
map("v", "<C-f>", ":s/foo/bar", opts)

map("n", "<leader>t", ":OverseerRun<CR>", opts)
map("n", "<leader>T", ":OverseerToggle<CR>", opts)

map("n", "<leader>ca", function()
	require("tiny-code-action").code_action()
end, opts)

for i = 1, 9 do
	map("n", "<A-" .. i .. ">", function()
		local buffers = vim.fn.getbufinfo({ buflisted = 1 })
		if buffers[i] then
			vim.cmd("buffer " .. buffers[i].bufnr)
		end
	end)
end

map("n", "<C-q>", ui.bufremove, opts)

map("n", "<leader>g", ":lua Lazygit_toggle()<CR>", opts)

-- General
map("n", "<leader>d", '"_d', opts)
map("v", "<leader>d", '"_d', opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- LSP
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
map("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

-- Navigation
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", opts)
map("n", "<leader>fs", "<cmd>Telescope grep_string<CR>", opts)

-- Splits
map("n", "<leader>sv", "<C-w>v", opts)
map("n", "<leader>sh", "<C-w>s", opts)
map("n", "<leader>se", "<C-w>=", opts)
map("n", "<leader>sx", "<cmd>close<CR>", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffers
map("n", "<Tab>", "<cmd>bnext<CR>", opts)
map("n", "<S-Tab>", "<cmd>bprevious<CR>", opts)
map("n", "<leader>bd", "<cmd>bdelete<CR>", opts)

-- Git
map("n", "<leader>gb", function()
	Snacks.git.blame_line()
end, opts)
map("n", "<leader>gd", function()
	Snacks.picker.git_diff()
end, opts)
map("n", "<leader>gh", function()
	Snacks.picker.git_log_file()
end, opts)
map("n", "<leader>gs", function()
	Snacks.picker.git_status()
end, opts)

-- DAP / Debugging
map("n", "<F5>", '<cmd>lua require"dap".continue()<CR>', opts)
map("n", "<F10>", '<cmd>lua require"dap".step_over()<CR>', opts)
map("n", "<F11>", '<cmd>lua require"dap".step_into()<CR>', opts)
map("n", "<F12>", '<cmd>lua require"dap".step_out()<CR>', opts)
map("n", "<leader>db", '<cmd>lua require"dap".toggle_breakpoint()<CR>', opts)
map("n", "<leader>dB", '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', opts)
map("n", "<leader>du", '<cmd>lua require"dapui".toggle()<CR>', opts)

-- Neotest & Terminal Splits
map("n", "<leader>tn", '<cmd>lua require("neotest").run.run()<CR>', opts)
map("n", "<leader>ts", '<cmd>lua require("neotest").summary.toggle()<CR>', opts)
map("n", "<leader>td", '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>', opts)
