return {
	"nvim-treesitter/nvim-treesitter",
	--lazy = true,

	config = function()
		vim.opt.foldmethod = 'expr'
		vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
		vim.cmd(':set nofoldenable')

		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"javascript", "typescript", "html",
				"svelte", "scss",
				"vim", "query",
				"c", "cpp",
				"go",
				"lua",
				"bash",
				"gitignore", "gitcommit",
				"sql",
			},

			highlight = {
				enable = true,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			indent = {
				enable = true
			},

			autotag = {
				enable = true,
			}
		})
	end
}
