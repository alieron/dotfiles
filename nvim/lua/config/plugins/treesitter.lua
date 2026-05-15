return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "c", "cpp", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx",
        "markdown", "markdown_inline", "astro", "java", "python", "make", "json",
        "rust", "yaml", "zig", "odin",
      }

      require("nvim-treesitter").setup {
        install_dir = vim.fn.stdpath("data") .. "/site",
      }

      require("nvim-treesitter").install(parsers)

      -- Large file highlight disable
      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function(args)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
          if ok and stats and stats.size > 100 * 1024 then
            return
          end

          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  }
}
