return {
	'Shatur/neovim-session-manager',

	dependencies = {
		'nvim-lua/plenary.nvim'
	},

	config = function()
		local config = require('session_manager.config')
		require('session_manager').setup({
			autoload_mode = config.AutoloadMode.Disabled, -- Define what to do when Neovim is started without arguments. See "Autoload mode" section below.
			autosave_last_session = true, -- Automatically save last session on exit and on session switch.
			autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
			autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
			autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
				'gitcommit',
				'gitrebase',
			},
			autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
			autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
			max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
		})
	end
}
