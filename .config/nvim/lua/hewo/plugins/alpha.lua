return {
	'goolord/alpha-nvim',

	dependencies = {
		'Shatur/neovim-session-manager',
		'nvim-tree/nvim-web-devicons',
	},

	config = function()
		--local startify = require("alpha.themes.startify")
		--startify.file_icons.provider = "devicons"

		local sessionManUtils = require("session_manager.utils")

		local headers = require("hewo.headers")
		local header = headers[math.random(#headers)]

		local function center(text, hl)
			return {
				val = text,
				type = "text",
				opts = {
					hl = hl,
					position = "center",
				},
			}
		end

		local function category(text, items)
			return {
				type = "group",
				val = {
					{
						type = "text",
						val = text,
						opts = {
							hl = "SpecialComment",
							position = "center",
							padding = 50,
						},
					},
					unpack(items)
				},
			}
		end

		local function button(text, hl, onPress, shortcut)
			local l = {
				val = text,
				type = "button",
				on_press = onPress,
				opts = {
					hl = hl,
					position = "center",
				},
			}

			if shortcut ~= nil then
				l.opts.shortcut = "[" .. shortcut .. "]"
				l.opts.align_shortcut = "right"
				l.opts.width = 50
				l.opts.hl_shortcut = {
					{ "Operator", 0, 1 },
					{ "Number", 1, #shortcut + 1 },
					{ "Operator", #shortcut + 1, #shortcut + 2 },
				}

				l.opts.keymap = {
					"n",
					shortcut,
					onPress,
					{
						noremap = true,
						silent = true,
						nowait = true
					}
				}
			end

			return l
		end

		local function padding()
			return {
				type = "padding",
				val = 1,
			}
		end

		local keys = "qwertyuiop[]"
		local sessions = {}
		for i, s in ipairs(sessionManUtils.get_sessions({ silent = true })) do
			table.insert(sessions, button(s.dir.filename, "String", function()
				sessionManUtils.load_session(s.filename, true)
			end, keys:sub(i, i)))
		end

		local treelib = require("nvim-tree.lib")
		local version = vim.version()
		local lazy = require("lazy")
		local alpha = require("alpha")
		alpha.setup({
			layout = {
				center(header, "Comment"),

				category("Sessions", sessions),

				category("Shortcuts", {
					button("dev", "String", function()
						treelib.open({ path = os.getenv("HOME") .. "/dev" })
					end, "a"),
					button("config", "String", function()
						treelib.open({ path = os.getenv("HOME") .. "/.config" })
					end, "s"),
					button("lazy", "String", function()
						vim.cmd("Lazy")
					end, "d"),
				}),

				padding(),
				padding(),
				category("---", {
					center("nvim " .. table.concat({ version.major, version.minor, version.patch }, '.'), "Comment"),
					center(function ()
						return "startup " .. lazy.stats().startuptime .. "ms"
					end, "Comment"),
					center(function()
						return "plugins " .. lazy.stats().loaded .. "/" .. lazy.stats().count
					end, "Comment"),
					center(function()
						return os.date("%Y-%m-%d %I:%M:%S %p")
					end, "Comment"),
				}),
			},
		})
	end,
}
