return {
	"nvim-tree/nvim-tree.lua",

	config = function()
		require("nvim-tree").setup({
			disable_netrw = false,
			hijack_netrw = true,
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				local core = require("nvim-tree.core")

				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				local function cdIfNecessary()
					local node = core.get_explorer():get_node_at_cursor()
					if node and node.type == "directory" then
						vim.cmd.cd(node.absolute_path)
					end
				end

				api.config.mappings.default_on_attach(bufnr)

				vim.keymap.set('n', '<C-e>', api.tree.close, opts('close'))
				vim.keymap.set('n', 'h', function()
					api.node.open.edit()
					cdIfNecessary()
				end, opts("unexpand"))

				vim.keymap.set('n', 'l', function()
					local node = core.get_explorer():get_node_at_cursor()

					api.node.open.edit()

					if node then
						if node.type == "file" then
							api.tree.close()
						end
					end
				end, opts('open and close tree or expand'))

				vim.keymap.set('n', '<S-l>', function()
					local node = core.get_explorer():get_node_at_cursor()

					if node ~= nil and node.type ~= "file" then
						api.tree.change_root_to_node(node)
						vim.cmd.cd(node.absolute_path);
					else
						api.node.open.edit()
						api.tree.close()
					end
				end, opts('change dir or edit'))
			end
		})
	end
}
