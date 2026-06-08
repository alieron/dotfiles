-- Format/rename/go to reference with lsp
vim.keymap.set('n', 'gf', vim.lsp.buf.format)
vim.keymap.set('n', 'grn', vim.lsp.buf.rename)
-- vim.keymap.set('n', 'gra', vim.lsp.buf.code_action) -- default in 0.11
vim.keymap.set('n', 'grr', vim.lsp.buf.references)

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Set capabilities and shared defaults for all servers
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- Servers with custom config
      vim.lsp.config('basedpyright', {
        single_file_support = true,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
            },
          },
        },
      })

      vim.lsp.config('ruff', {
        single_file_support = true,
      })

      -- Enable all servers
      vim.lsp.enable({
        'basedpyright',
        'ruff',
        'lua_ls',
        'clangd',
        'jsonls',
        'ts_ls',
        'astro',
        'jdtls',
        'svelte',
        'rust_analyzer',
        'yamlls',
      })

      -- remove trailing whitespace when buffer is written
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("XXX/whitespace", {}),
        pattern = "*",
        command = [[%s/\s\+$//e]],
      })

      -- YAML uses spaces, not tabs
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'yaml',
        callback = function(args)
          vim.bo[args.buf].expandtab = true
          vim.bo[args.buf].tabstop = 2
          vim.bo[args.buf].shiftwidth = 2
          vim.bo[args.buf].softtabstop = 2
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then return end

          local ft = vim.bo[args.buf].filetype

          -- Auto-format tabs to spaces in YAML files on save
          if ft == "yaml" then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                -- Convert literal tab characters to spaces before saving
                vim.cmd([[silent! %s/\t/  /ge]])

                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          end

          -- Auto-format Lua files on save
          if ft == "lua" then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          end
        end,
      })
    end,
  }
}
