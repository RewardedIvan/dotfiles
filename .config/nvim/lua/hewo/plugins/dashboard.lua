return {
	"MeanderingProgrammer/dashboard.nvim",
	enabled = false,
    event = 'VimEnter',
    dependencies = {
        { 'MaximilianLloyd/ascii.nvim', dependencies = { 'MunifTanjim/nui.nvim' } },
    },

    config = function()
		local headers = require("hewo.headers")

        require('dashboard').setup({
			header = headers[math.random(#headers)],
            directories = require("project_nvim").get_recent_projects(),
			footer = {
				function ()
					local version = vim.version()
					local versions = { version.major, version.minor, version.patch }
					return 'nvim ' .. table.concat(versions, '.')
				end,

				function ()
					local lazy = require("lazy");
					return "plugins " .. lazy.stats().loaded .. "/" .. lazy.stats().count
				end,

				function ()
					local lazy = require("lazy");
					return "startup " .. math.floor(lazy.stats().startuptime * 10) / 10 .. "ms"
				end,

				function()
					return os.date("%Y-%m-%d %I:%M:%S %p")
				end,
			},
			highlight_groups = {
				header = 'Comment',
				icon = 'Type',
				directory = 'Delimiter',
				hotkey = 'Statement',
			},
        })
    end,
}
