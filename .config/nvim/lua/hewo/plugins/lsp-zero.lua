return {
	"VonHeikemen/lsp-zero.nvim",
	branch = 'v3.x',
	module = true,

	dependencies = {
		{ 'hrsh7th/cmp-nvim-lsp' },
		require("hewo.plugins.cmp"),
		require("hewo.plugins.lsp-config"),
		{ 'L3MON4D3/LuaSnip' },
	},

	config = function()
		vim.g.lsp_zero_extend_lspconfig = 0
		local lspz = require("lsp-zero")


		lspz.set_sign_icons({
			error = '✘',
			warn = '▲',
			hint = '⚑',
			info = '»'
		})

		lspz.on_attach(function(client, bufnr)
			lspz.default_keymaps({buffer = bufnr})
		end)
	end,
}
