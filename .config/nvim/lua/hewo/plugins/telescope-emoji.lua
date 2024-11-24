return {
	"xiyaowong/telescope-emoji.nvim",
	lazy = true,

	dependencies = { "nvim-telescope/telescope.nvim" },

	config = function()
		require("telescope").load_extension("emoji")
	end,
}
