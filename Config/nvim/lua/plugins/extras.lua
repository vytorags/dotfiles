return {
  {
    "mistricky/codesnap.nvim",
    tag = "v1.6.3",
  },
  { "HiPhish/rainbow-delimiters.nvim" },
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      enable_tailwind = true,
      render = "virtual",
      virtual_symbol = "",
    },
  },
  { "nvimdev/lspsaga.nvim" },
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  { "MeanderingProgrammer/render-markdown.nvim" },
  { "windwp/nvim-ts-autotag",                   opts = {} },
  { "nvim-tree/nvim-web-devicons",              opts = {} },
  { "windwp/nvim-autopairs",                    opts = {} },
  { "stevearc/overseer.nvim",                   opts = {} },
  { "folke/which-key.nvim",                     opts = {} },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  { "nvim-lua/plenary.nvim",                  lazy = true },
  {
    "rachartier/tiny-code-action.nvim",
    opts = { picker = "buffer" },
  },
  { "rachartier/tiny-inline-diagnostic.nvim", opts = {} },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.5,
      trailing_stiffness = 0.49,
      never_draw_over_target = false,
      legacy_computing_symbols_support = true,
      distance_stop_animating_vertical_bar = 0.1,
      smear_insert_mode = true,
    },
  },
  { "RRethy/vim-illuminate" }
}
