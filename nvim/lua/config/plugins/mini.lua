-- lua/custom/plugins/mini.lua
return {
	{
		'echasnovski/mini.statusline',
		enabled = true,
		config = function()
			local statusline = require 'mini.statusline'
			statusline.setup { use_icons = true }
		end
	},
    {
        'echasnovski/mini.bracketed',
		enabled = true,
		config = function()
			local bracketed = require 'mini.bracketed'
            bracketed.setup()
		end
    },
    {
        'echasnovski/mini.ai',
		enabled = true,
		config = function()
			local ai = require 'mini.ai'
            ai.setup()
		end
    },
    -- {
    --     'echasnovski/mini.comment',
	-- 	enabled = true,
    --     config = function()
	-- 		local comment = require 'mini.comment'
    --         comment.setup({
    --             opts = {
    --                 options = {
    --                     custom_commentstring = function() 
    --                         for _,ext in pairs({ "c", "cpp", "objc", "objcpp", "cuda", "proto" }) do
    --                             if vim.bo.filetype == ext then
    --                                 return "// %s"
    --                             end
    --                         end
    --                         return vim.bo.commentstring
    --                     end
    --                 }
    --             }
    --         })
	-- 	end
    -- },
}