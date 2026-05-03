local ts = vim.treesitter

local function highlight_placeholders(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lang = vim.bo[bufnr].filetype
  local parser = ts.get_parser(bufnr, lang)
  if not parser then
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()

  local query = vim.treesitter.query.get(lang, 'highlights')
  if not query then
    return
  end

  for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
    local name = query.captures[id]
    if name == 'string' or name == 'interpreted_string_literal' then
      local text = ts.get_node_text(node, bufnr)
      local start_row, start_col, end_row, end_col = node:range()

      for s, e in text:gmatch '()%%[0-9]*[sdxXf]()' do
        vim.api.nvim_buf_add_highlight(bufnr, -1, 'Type', start_row, start_col + s - 1, start_col + e - 1)
      end
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'TextChanged', 'TextChangedI' }, {
  pattern = { '*.c', '*.h', '*.go', '*.cpp' },
  callback = function()
    highlight_placeholders()
  end,
})
