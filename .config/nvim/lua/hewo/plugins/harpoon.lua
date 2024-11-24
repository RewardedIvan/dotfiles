return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',

	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- i cant get it right...
		--vim.keymap.set('n', '<C-q>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { noremap = true })
		--vim.keymap.set("n", "<C-a>", function() harpoon:list():add() end)
		--vim.keymap.set("n", "<S-r>", function() harpoon:list():remove() end)
	end
}
