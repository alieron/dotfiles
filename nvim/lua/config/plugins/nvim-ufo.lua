local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end

local function fold_siblings(action)
  local cur = vim.api.nvim_win_get_cursor(0)
  local line = cur[1]
  local level = vim.fn.foldlevel(line)

  if level <= 0 then
    return
  end

  local last = vim.fn.line("$")

  -- Find parent range: the nearest area containing folds at this level.
  local start_line = 1
  for l = line - 1, 1, -1 do
    if vim.fn.foldlevel(l) < level then
      start_line = l + 1
      break
    end
  end

  local end_line = last
  for l = line + 1, last do
    if vim.fn.foldlevel(l) < level then
      end_line = l - 1
      break
    end
  end

  local view = vim.fn.winsaveview()

  for l = start_line, end_line do
    local this_level = vim.fn.foldlevel(l)
    local prev_level = l > 1 and vim.fn.foldlevel(l - 1) or 0

    -- Only act on the start of sibling folds at the same level.
    if this_level == level and prev_level < level then
      vim.api.nvim_win_set_cursor(0, { l, 0 })

      if action == "close" then
        vim.cmd("normal! zc")
      elseif action == "open" then
        vim.cmd("normal! zo")
      end
    end
  end

  vim.fn.winrestview(view)
end

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'

      require("ufo").setup({
        fold_virt_text_handler = handler,
        open_fold_hl_timeout = 150,
        preview = {
          win_config = {
            border = { '', '─', '', '', '', '─', '', '' },
            winhighlight = 'Normal:Folded',
            winblend = 0
          },
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
          }
        },

        provider_selector = function(_, filetype, _)
          -- Avoid treesitter provider for filetypes that often have missing/noisy fold queries
          if filetype == "markdown" or filetype == "text" or filetype == "help" then
            return { "indent" }
          end

          -- Safer than { "lsp", "treesitter" }
          return { "lsp", "indent" }
        end,
      })

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc })
      end

      -- Fold current indent/block
      map("n", "zc", "zc", "Close current fold")

      -- Open current indent/block
      map("n", "zo", "zo", "Open current fold")

      -- Fold sibling indents/blocks
      map("n", "zC", function()
        fold_siblings("close")
      end, "Close sibling folds at current level")

      -- Open sibling indents/blocks
      map("n", "zO", function()
        fold_siblings("open")
      end, "Open sibling folds at current level")

      -- Optional: preview folded lines under cursor
      map("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover({ border = "rounded" })
        end
      end, "Peek fold or hover")
    end,
  },
}
