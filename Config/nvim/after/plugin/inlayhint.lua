local function setup_inlay_hints()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end
    end,
  })

  local function hl(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
  end

  local function set_inlay_highlights()
    local normal = hl 'Normal'
    local comment = hl 'Comment'
    local type = hl 'Type'
    local identifier = hl 'Identifier'
    local line_nr = hl 'LineNr'
    local nontext = hl 'NonText'
    local folded = hl 'Folded'

    local bg = folded.bg or line_nr.bg or nontext.bg or normal.bg

    vim.api.nvim_set_hl(0, 'LspInlayHint', {
      fg = comment.fg or line_nr.fg or normal.fg,
      bg = bg,
      italic = true,
    })

    vim.api.nvim_set_hl(0, 'LspInlayHintType', {
      fg = type.fg or comment.fg or normal.fg,
      bg = bg,
      italic = true,
    })

    vim.api.nvim_set_hl(0, 'LspInlayHintParameter', {
      fg = identifier.fg or comment.fg or normal.fg,
      bg = bg,
      italic = true,
    })
  end

  set_inlay_highlights()

  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = set_inlay_highlights,
  })

  local original_handler = vim.lsp.handlers['textDocument/inlayHint']

  vim.lsp.handlers['textDocument/inlayHint'] = function(err, result, ctx, config)
    if not result then
      return original_handler(err, result, ctx, config)
    end

    for _, hint in ipairs(result) do
      local label = hint.label
      local prefix = ''

      if hint.kind == 1 then
        prefix = '󰜁 '
      elseif hint.kind == 2 then
        prefix = '󰏪 '
      end

      if type(label) == 'string' then
        if not label:match('^' .. prefix) then
          hint.label = prefix .. label
        end
      elseif type(label) == 'table' then
        if label[1] and label[1].value and not label[1].value:match('^' .. prefix) then
          label[1].value = prefix .. label[1].value
        end
      end
    end

    return original_handler(err, result, ctx, config)
  end

  vim.keymap.set('n', '<leader>ih', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = 'Toggle Inlay Hints globally' })
end

setup_inlay_hints()
