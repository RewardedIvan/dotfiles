return {
	'hrsh7th/nvim-cmp',
	lazy = true,

	--dependendencies = { "VonHeikemen/lsp-zero.nvim" },

	config = function()
		local cmp = require("cmp")
		--local lspz = require("lsp-zero")
		local luasnip = require("luasnip")

		local cmp_kinds = {
			Text = '  ',
			Method = '  ',
			Function = '  ',
			Constructor = '  ',
			Field = '  ',
			Variable = '  ',
			Class = '  ',
			Interface = '  ',
			Module = '  ',
			Property = '  ',
			Unit = '  ',
			Value = '  ',
			Enum = '  ',
			Keyword = '  ',
			Snippet = '  ',
			Color = '  ',
			File = '  ',
			Reference = '  ',
			Folder = '  ',
			EnumMember = '  ',
			Constant = '  ',
			Struct = '  ',
			Event = '  ',
			Operator = '  ',
			TypeParameter = '  ',
		}
		
		local has_words_before = function()
			unpack = unpack or table.unpack
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			window = {
				completion = cmp.config.window.bordered()
			},

			formatting = {
				fields = { "kind", "abbr" },
				format = function(_, vim_item)
					vim_item.kind = cmp_kinds[vim_item.kind] or ""
					return vim_item
				end,
			},

			mapping = {
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
						-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
						-- that way you will only jump inside the snippet region
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
						if #cmp.get_entries() == 1 then
							cmp.confirm({ select = true })
						end
					else
						fallback()
					end
				end, { "i", "s" }),
				
				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.complete()
						cmp.confirm()
						-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
						-- that way you will only jump inside the snippet region
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<C-Space>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						fallback()
					else
						cmp.complete()
					end
				end, { "i", "s" }),
			}
		})
		
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		
		cmp.event:on(
		  'confirm_done',
		  cmp_autopairs.on_confirm_done()
		)
	end
}
