return {
    "nvim-telescope/telescope.nvim",
    keys = function()
        local builtin = require('telescope.builtin')
        -- mappings for telescope
        return {
            { "<leader>ff", builtin.find_files, desc = "Find Files" },
            { "<leader>fa", function() builtin.find_files({no_ignore=true}) end, desc = "Find All"},
            { '<leader>fg', builtin.live_grep, desc = "Find Live Grep" },
            { "<leader>fb", builtin.buffers, desc = "Find Buffers" },
            { "<leader>fr", builtin.oldfiles, desc = "Find Recent" },
            { "<leader>fs", builtin.current_buffer_fuzzy_find, desc = "Find in Current Buffer" },
            { "<leader>ft", builtin.treesitter, desc = "Find in Treesitter" },
        }
    end,
  }