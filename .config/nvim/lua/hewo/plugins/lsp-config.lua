return {
	"neovim/nvim-lspconfig",
	lazy = true,

	dependencies = {
		require("hewo.plugins.lazydev"),
		require("hewo.plugins.schemastore"),
	},

	config = function()
		local lspc = require("lspconfig")

		lspc.lua_ls.setup({
			on_init = function(client)
				--local path = client.workspace_folders[1].name
				--if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
				--	return
				--end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							"/usr/share/awesome/lib",
							"/usr/share/lua/5.4",
							-- Depending on the usage, you might want to add additional paths here.
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						},
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					},
				})
			end,
			settings = {
				Lua = {},
			},
		})
		lspc.ts_ls.setup({})
		lspc.clangd.setup({})
		lspc.svelte.setup({})
		lspc.rust_analyzer.setup({})
		lspc.gopls.setup({})
		lspc.tailwindcss.setup({})
		lspc.cssls.setup({})
		lspc.html.setup({})
		lspc.jsonls.setup({
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})
	end,
}
