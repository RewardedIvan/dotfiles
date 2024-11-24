return {
	"mbbill/undotree",
	lazy = true,
	
	config = function()
		vim.keymap.set("n", "<C-S>U", vim.cmd.UndotreeToggle)
	end
}
