return {
  "saghen/blink.cmp",
  branch = "v1.10.2",
  name = "blink",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "echasnovski/mini.icons",
    "L3MON4D3/LuaSnip",
  },
  event = "InsertEnter",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()

    vim.api.nvim_set_hl(0, "CmpMenu", { bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKind", { link = "Comment" })

    require("blink.cmp").setup({
      keymap = {
        preset = "default",
        ["<CR>"] = {
          "accept",
          "fallback",
        },
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
        ["<Down>"] = {},
        ["<Up>"] = {},
      },

      appearance = {
        use_nvim_cmp_as_default = true,
      },

      completion = {
        menu = {
          winhighlight = "Normal:BlinkMenu,FloatBorder:BlinkMenu,CursorLine:Visual,Search:None",
          draw = {
            columns = {
              { "kind_icon", "kind",             gap = 1 },
              { "label",     "label_description" },
            },
          },
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        documentation = {
          auto_show = true,
          window = {
            winhighlight = "Normal:BlinkMenu,FloatBorder:BlinkMenu,CursorLine:Visual,Search:None",
          },
        },
        trigger = {
          show_on_blocked_trigger_characters = function()
            local chars = { "'", '"', "(", "{", "[" }
            local target_fts = { "html", "php", "vue", "reactjs", "javascriptreact", "typescriptreact" }
            if vim.tbl_contains(target_fts, vim.bo.filetype) then
              table.insert(chars, ">")
            end
            return chars
          end,
        },
      },

      snippets = {
        preset = "luasnip",
      },

      sources = {
        providers = {
          lsp = {
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                return item.label ~= "{}"
              end, items)
            end,
          },
        },
      },
    })
  end,
}
