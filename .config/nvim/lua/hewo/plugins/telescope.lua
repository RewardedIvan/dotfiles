return {
	'nvim-telescope/telescope.nvim', tag = '0.1.5',
	lazy = true,

	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		local telescope = require('telescope')
		local builtin = require('telescope.builtin')

		telescope.setup({
			defaults = {
				file_ignore_patterns = {
					"node_modules", "build", ".next",
					".png", ".jpg", ".jpeg", ".ico",
					".db", ".sqlite", ".exe",
					".git",
				}
			},

			extensions = {
				fzf = {
					fuzzy = true,                    -- false will only do exact matching
					override_generic_sorter = true,  -- override the generic sorter
					override_file_sorter = true,     -- override the file sorter
					case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				}
			},
		})
	end,
}
