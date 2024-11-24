return {
	"nvim-tree/nvim-tree.lua",

	config = function()
		require("nvim-tree").setup({
			disable_netrw = true,
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				api.config.mappings.default_on_attach(bufnr)

				local function edit()
					local node = api.tree.get_node_under_cursor()

					api.node.open.edit()
					if node and node.type == "file" then
						api.tree.close()
					end
				end

				vim.keymap.set('n', '<C-e>', api.tree.close, opts('close'))
				vim.keymap.set('n', 'h', edit, opts("open and close tree or expand"))
				vim.keymap.set('n', 'l', edit, opts("open and close tree or expand"))

				vim.keymap.set('n', '<S-l>', function()
					local node = api.tree.get_node_under_cursor()

					if node then
						if node.type == "directory" or node.name == ".." then
							api.tree.change_root_to_node(node)
						else
							api.node.open.edit()
							api.tree.close()
						end
					end
				end, opts('change dir or edit'))
			end
		})
	end
}
