return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require("noice").setup({
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "cmdline",
            find = "Press any key to continue",
          },
          opts = { skip = true, silent = true },
        },
      },
      lsp = {
        progress = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    })
  end,
}
