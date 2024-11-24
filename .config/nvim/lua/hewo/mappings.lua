-- motion
vim.keymap.set("", "<C-j>", "<C-d>", {})
vim.keymap.set("", "<C-k>", "<C-u>", {})

vim.keymap.set("", "<C-h>", "_", {})
vim.keymap.set("", "<C-l>", "$", {})

-- pasting from os clipboard
vim.api.nvim_set_keymap("n", "<C-v>", '"+p', {})
vim.api.nvim_set_keymap("i", "<C-v>", '<esc>"+pa', {})

-- buffers
vim.keymap.set("n", "<tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-tab>", vim.cmd.bprev)
vim.keymap.set("n", " <tab>", vim.cmd.bdel)

-- telescope
vim.keymap.set("n", "<C-f>", require("telescope.builtin").find_files, {})
vim.keymap.set("n", "<S-f>", require("telescope.builtin").live_grep, {})
-- nvim tree
vim.keymap.set("n", "<C-e>", vim.cmd.NvimTreeToggle, { noremap = true })
-- harpoon in plugins/

-- lsp
vim.keymap.set("n", ";", vim.lsp.buf.hover)
vim.keymap.set('n', '<C-;>', vim.diagnostic.open_float)
vim.keymap.set("n", "<C-S-r>", require("renamer").rename)

--[[terminals
vim.keymap.set('n', '<C-t>', vim.cmd.terminal)
vim.keymap.set('t', '<C-w>', "<C-BS>", { noremap = true })
--]]
vim.keymap.set("n", "<C-t>", vim.cmd.ToggleTerm)
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { noremap = true })

-- indentation
vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })

vim.keymap.set("n", ">", "<S-v>>", {})
vim.keymap.set("n", "<", "<S-v><", {})
