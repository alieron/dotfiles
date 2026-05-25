return {
  "nvim-telescope/telescope.nvim",
  keys = function()
    local builtin = require('telescope.builtin')
    -- mappings for telescope
    return {
      {
        "<leader>ff",
        function()
          -- add no-ignore = true to find .gitignored files
          builtin.find_files({ hidden = true, follow = true, find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--exclude", "node_modules" }, })
        end,
        desc = "Find Files"
      },
      { "<leader>fa", function() builtin.find_files({ hidden = true }) end, desc = "Find All" },
      { '<leader>fg', builtin.live_grep,                                    desc = "Find Live Grep" },
      { "<leader>fb", builtin.buffers,                                      desc = "Find Buffers" },
      { "<leader>fr", builtin.oldfiles,                                     desc = "Find Recent" },
      { "<leader>fs", builtin.current_buffer_fuzzy_find,                    desc = "Find in Current Buffer" },
      { "<leader>ft", builtin.treesitter,                                   desc = "Find in Treesitter" },
      {
        "<leader>fu",
        function()
          builtin.git_files({
            prompt_title = "Unstaged changes", git_command = { "git", "diff", "--name-only", "--diff-filter=ACMR", }, })
        end,
        desc = "Find All Unstaged"
      },
    }
  end,
}
