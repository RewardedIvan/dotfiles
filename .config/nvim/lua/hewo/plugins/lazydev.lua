return {
	"folke/lazydev.nvim",
	ft = "lua",
	module = true,

	config = function()
		require("lazydev").setup()
	end
}
