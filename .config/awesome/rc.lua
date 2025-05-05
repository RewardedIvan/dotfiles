local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
--local ruled = require("config.rules")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local rubato = require("modules.rubato")

local function error_handling()
	if awesome.startup_errors then
		naughty.notify({ preset = naughty.config.presets.critical,
						 title = "Oops, there were errors during startup!",
						 text = awesome.startup_errors })
	end
	do
		local in_error = false
		awesome.connect_signal("debug::error", function (err)
			-- Make sure we don't go into an endless error loop
			if in_error then return end
			in_error = true

			naughty.notify({ preset = naughty.config.presets.critical,
							 title = "Oops, an error happened!",
							 text = tostring(err) })
			in_error = false
		end)
	end
end

local modkey = "Mod4" -- super, the windows key
local terminal = "kitty"

menubar.utils.terminal = terminal

local ui = {}
ui.myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", "neovide " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

ui.mymainmenu = awful.menu({ items = { { "awesome", ui.myawesomemenu, beautiful.awesome_icon },
									{ "open terminal", terminal }
								  }
						})
ui.mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
									 menu = ui.mymainmenu })
ui.mykeyboardlayout = awful.widget.keyboardlayout()
ui.mytextclock = wibox.widget.textclock()

local function set_theme()
	beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

	client.connect_signal("focus", function(c) c.border_color = beautiful.border_color_active end)
	client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_color_normal end)
end

local function get_client_mousebinds()
	return gears.table.join(
		awful.button({ }, 1, function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
		end),
		awful.button({ modkey }, 1, function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
			awful.mouse.client.move(c)
		end),
		awful.button({ modkey }, 3, function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
			awful.mouse.client.resize(c)
		end)
	)
end

local default_layout = awful.layout.suit.tile.left
local function set_layouts()
	awful.layout.layouts = {
		awful.layout.suit.tile.left,
		awful.layout.suit.max,
		awful.layout.suit.floating,
	}
end

local function set_monitors()
	awful.screen.connect_for_each_screen(function (s)
		s:connect_signal('property::geometry', function ()
			awesome.restart()
		end)
	end)
end

local function set_global_mousebinds()
	root.buttons(gears.table.join(
		awful.button({ }, 3, function () ui.mymainmenu:toggle() end),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev)
	))
end

local function set_layout_on_all_tags(l)
	for _, t in pairs(awful.screen.focused().tags) do
		t.layout = l
	end
end

local function set_global_keybinds()
	local function call_scrot(args)
		return awful.spawn("scrot " .. args .. " -F \"/tmp/%Y-%m-%d-%H%M%S_\\$wx\\$h_scrot.png\" -e 'xclip -selection clipboard -t image/png -i $f'")
	end

	local global_binds = gears.table.join(
        awful.key({ modkey, "Shift" }, "r", awesome.restart,
                  {description = "reload awesome", group = "awesome"}),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"}),
        awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
                  {description = "open a terminal", group = "launcher"}),
		awful.key(
            { "Control", "Shift" }, 'Tab',
            function ()
				call_scrot("--select")
            end,
            { description = 'region screenshot', group = 'launcher' }
        ),
		awful.key(
            { }, 'Print',
            function ()
				call_scrot("")
            end,
            { description = 'full screenshot', group = 'launcher' }
        ),
		awful.key({ modkey }, "r", function () awful.spawn("rofi -show drun") end,
			{description = "Open rofi", group = "launcher"}),

        awful.key({ modkey }, "Tab", awful.tag.history.restore,
                  {description = "go back", group = "tag"}),

		awful.key({ modkey,           }, "j",
			function ()
				awful.client.focus.byidx( 1)
			end,
			{description = "focus next by index", group = "client"}
		),
		awful.key({ modkey,           }, "k",
			function ()
				awful.client.focus.byidx(-1)
			end,
			{description = "focus previous by index", group = "client"}
		),

        -- awful.key {
        --     modifiers   = { modkey },
        --     keygroup    = "numpad",
        --     description = "select layout directly",
        --     group       = "layout",
        --     on_press    = function (index)
        --         local t = awful.screen.focused().selected_tag
        --         if t then
        --             t.layout = t.layouts[index] or t.layout
        --         end
        --     end,
        -- }
		awful.key(
			{ modkey }, "m", function () set_layout_on_all_tags(awful.layout.suit.max) end,
			{description = "Monocycle/max", group = "layout"}
		),
		awful.key(
			{ modkey }, "space", function () set_layout_on_all_tags(awful.layout.suit.floating) end,
			{description = "Floating", group = "layout"}
		),
		awful.key(
			{ modkey }, "t", function () set_layout_on_all_tags(awful.layout.suit.tile) end,
			{description = "Tile", group = "layout"}
		)
	)

	for i = 1, 9 do
		global_binds = gears.table.join(global_binds,
			-- View tag only.
			awful.key({ modkey }, "#" .. i + 9,
					  function ()
							local screen = awful.screen.focused()
							local tag = screen.tags[i]
							if tag then
							   tag:view_only()
							end
					  end,
					  {description = "view tag #"..i, group = "tag"}),
			-- Toggle tag display.
			awful.key({ modkey, "Control" }, "#" .. i + 9,
					  function ()
						  local screen = awful.screen.focused()
						  local tag = screen.tags[i]
						  if tag then
							 awful.tag.viewtoggle(tag)
						  end
					  end,
					  {description = "toggle tag #" .. i, group = "tag"}),
			-- Move client to tag.
			awful.key({ modkey, "Shift" }, "#" .. i + 9,
					  function ()
						  if client.focus then
							  local tag = client.focus.screen.tags[i]
							  if tag then
								  client.focus:move_to_tag(tag)
							  end
						 end
					  end,
					  {description = "move focused client to tag #"..i, group = "tag"}),
			-- Toggle tag on focused client.
			awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
					  function ()
						  if client.focus then
							  local tag = client.focus.screen.tags[i]
							  if tag then
								  client.focus:toggle_tag(tag)
							  end
						  end
					  end,
					  {description = "toggle focused client on tag #" .. i, group = "tag"})
		)
	end

	root.keys(global_binds)
end

local function get_client_keybinds()
	return gears.table.join(
		awful.key({ modkey,           }, "f",
			function (c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end,
			{description = "toggle fullscreen", group = "client"}),
		awful.key({ modkey   }, "Escape",      function (c) c:kill()                         end,
				{description = "close", group = "client"}),
		awful.key({ modkey, "Shift" }, "space",  awful.client.floating.toggle                     ,
				{description = "toggle floating", group = "client"}),
		awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
				{description = "move to master", group = "client"}),
		awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
				{description = "move to screen", group = "client"}),
		awful.key({ modkey, "Shift" }, "t",      function (c) c.ontop = not c.ontop            end,
				{description = "toggle keep on top", group = "client"})
		-- awful.key({ modkey,           }, "m",
		--     function (c)
		--         c.maximized = not c.maximized
		--         c:raise()
		--     end ,
		--     {description = "(un)maximize", group = "client"}),
		-- awful.key({ modkey, "Control" }, "m",
		--     function (c)
		--         c.maximized_vertical = not c.maximized_vertical
		--         c:raise()
		--     end ,
		--     {description = "(un)maximize vertically", group = "client"}),
		-- awful.key({ modkey, "Shift"   }, "m",
		--     function (c)
		--         c.maximized_horizontal = not c.maximized_horizontal
		--         c:raise()
		--     end ,
		--     {description = "(un)maximize horizontally", group = "client"}),
	)
end

local function set_floating_clients()
	client.connect_signal('request::manage', function (c)
		awful.placement.centered(c, {
			honor_workarea = true
		})
	end)
end

local function set_auto_focus()
	client.connect_signal("mouse::enter", function(c)
		c:emit_signal("request::activate", "mouse_enter", {raise = false})
	end)
end

local function set_rules()
	awful.rules.rules = {
		-- All clients will match this rule.
		{ rule = { },
		  properties = { border_width = beautiful.border_width,
						 border_color = beautiful.border_normal,
						 focus = awful.client.focus.filter,
						 raise = true,
						 keys = get_client_keybinds(),
						 buttons = get_client_mousebinds(),
						 screen = awful.screen.preferred,
						 placement = awful.placement.no_overlap+awful.placement.no_offscreen
		 }
		},

		-- Floating clients.
		{ rule_any = {
			instance = {
			  "DTA",  -- Firefox addon DownThemAll.
			  "copyq",  -- Includes session name in class.
			  "pinentry",
			},
			class = {
			  "Arandr",
			  "Blueman-manager",
			  "Gpick",
			  "Kruler",
			  "MessageWin",  -- kalarm.
			  "Sxiv",
			  "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			  "Wpa_gui",
			  "veromix",
			  "xtightvncviewer"},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
			  "Event Tester",  -- xev.
			},
			role = {
			  "AlarmWindow",  -- Thunderbird's calendar.
			  "ConfigManager",  -- Thunderbird's about:config.
			  "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
			}
		  }, properties = { floating = true }},

		-- Add titlebars to normal clients and dialogs
		{ rule_any = {type = { "normal", "dialog" }
		  }, properties = { titlebars_enabled = false }
		},

		-- Set Firefox to always map on the tag named "2" on screen 1.
		-- { rule = { class = "Firefox" },
		--   properties = { screen = 1, tag = "2" } },
	}
end

local function set_signals()
	client.connect_signal("manage", function (c)
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- if not awesome.startup then awful.client.setslave(c) end

		if awesome.startup
		  and not c.size_hints.user_position
		  and not c.size_hints.program_position then
			-- Prevent clients from being unreachable after screen count changes.
			awful.placement.no_offscreen(c)
		end
	end)

	-- Add a titlebar if titlebars_enabled is set to true in the rules.
	client.connect_signal("request::titlebars", function(c)
		-- buttons for the titlebar
		local buttons = gears.table.join(
			awful.button({ }, 1, function()
				c:emit_signal("request::activate", "titlebar", {raise = true})
				awful.mouse.client.move(c)
			end),
			awful.button({ }, 3, function()
				c:emit_signal("request::activate", "titlebar", {raise = true})
				awful.mouse.client.resize(c)
			end)
		)

		awful.titlebar(c) : setup {
			{ -- Left
				awful.titlebar.widget.iconwidget(c),
				buttons = buttons,
				layout  = wibox.layout.fixed.horizontal
			},
			{ -- Middle
				{ -- Title
					align  = "center",
					widget = awful.titlebar.widget.titlewidget(c)
				},
				buttons = buttons,
				layout  = wibox.layout.flex.horizontal
			},
			{ -- Right
				--awful.titlebar.widget.floatingbutton (c),
				--awful.titlebar.widget.maximizedbutton(c),
				--awful.titlebar.widget.stickybutton   (c),
				--awful.titlebar.widget.ontopbutton    (c),
				awful.titlebar.widget.closebutton    (c),
				layout = wibox.layout.fixed.horizontal()
			},
			layout = wibox.layout.align.horizontal
		}
	end)
end

local function enable_tag_preview(self, c3)
    self:connect_signal('mouse::enter', function ()
        if #c3:clients() > 0 then
            awesome.emit_signal('bling::tag_preview::update', c3)
            awesome.emit_signal('bling::tag_preview::visibility', s, true)
        end
    end)
    self:connect_signal('mouse::leave', function ()
        awesome.emit_signal('bling::tag_preview::visibility', s, false)
    end)
end

local function update_tags(self, index, s)
    local markup_role = self:get_children_by_id('markup_role')[1]

    local found = false
    local i = 1

    while i <= #s.selected_tags do
        if s.selected_tags[i].index == index then
            found = true
        end
        i = i + 1
    end

    if found then
        markup_role.image = gears.color.recolor_image(
            beautiful.selected_tag_format,
            beautiful.taglist_fg_focus
        )
    else
        markup_role.image = gears.color.recolor_image(
            beautiful.normal_tag_format,
            beautiful.taglist_fg
        )
        for _, c in ipairs(client.get(s)) do
            for _, t in ipairs(c:tags()) do
                if t.index == index then
                    markup_role.image = gears.color.recolor_image(
                        beautiful.occupied_tag_format,
                        beautiful.taglist_fg_occupied
                    )
                end
            end
        end
    end
end

local function render_taglist(s)
    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = {
            layout = wibox.layout.fixed.horizontal,
            spacing = 13,
        },
        style = {
            shape = gears.shape.circle,
        },
        buttons = gears.table.join(
            awful.button({}, 1, function (t)
                t:view_only()
            end),
            awful.button({}, 4, function (t)
                awful.tag.viewprev(t.screen)
            end),
            awful.button({}, 5, function (t)
                awful.tag.viewnext(t.screen)
            end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({ }, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end)
        ),
        widget_template = {
            {
                id = 'markup_role',
                image = nil,
                valign = 'center',
                halign = 'center',
                forced_height = beautiful.font_size * 1.5,
                forced_width = beautiful.font_size * 1.5,
                widget = wibox.widget.imagebox,
            },
            id = 'background_role',
            widget = wibox.container.background,
            shape = gears.shape.circle,
            update_callback = function (self, _, index)
                update_tags(self, index, s)
            end,
            create_callback = function (self, c3, index)
                enable_tag_preview(self, c3)
                update_tags(self, index, s)
            end,
        },
    }
end

local function set_ui()
	local tasklist_buttons = gears.table.join(
						 awful.button({ }, 1, function (c)
												  if c == client.focus then
													  c.minimized = true
												  else
													  c:emit_signal(
														  "request::activate",
														  "tasklist",
														  {raise = true}
													  )
												  end
											  end),
						 awful.button({ }, 3, function()
												  awful.menu.client_list({ theme = { width = 250 } })
											  end),
						 awful.button({ }, 4, function ()
												  awful.client.focus.byidx(1)
											  end),
						 awful.button({ }, 5, function ()
												  awful.client.focus.byidx(-1)
											  end))

	awful.screen.connect_for_each_screen(function(s)
		-- Wallpaper
		local function set_wallpaper()
			if beautiful.wallpaper then
				local wallpaper = beautiful.wallpaper
				-- If wallpaper is a function, call it with the screen
				if type(wallpaper) == "function" then
					wallpaper = wallpaper(s)
				end
				gears.wallpaper.maximized(wallpaper, s, true)
			end
		end
		set_wallpaper()

		-- Each screen has its own tag table.
		awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, default_layout)

		-- Create a promptbox for each screen
		s.mypromptbox = awful.widget.prompt()
		-- Create an imagebox widget which will contain an icon indicating which layout we're using.
		-- We need one layoutbox per screen.
		s.mylayoutbox = awful.widget.layoutbox(s)
		local function inc_lay(inc)
			local idx = awful.layout.get_tag_layout_index(awful.screen.focused().selected_tag)
			set_layout_on_all_tags(awful.layout.layouts[idx + inc])
		end
		s.mylayoutbox:buttons(gears.table.join(
							   awful.button({ }, 1, function () inc_lay( 1) end),
							   awful.button({ }, 3, function () inc_lay(-1) end),
							   awful.button({ }, 4, function () inc_lay( 1) end),
							   awful.button({ }, 5, function () inc_lay(-1) end)))
		-- Create a taglist widget
		s.mytaglist = render_taglist(s)

		-- Create a tasklist widget
		s.mytasklist = awful.widget.tasklist {
			screen  = s,
			filter  = awful.widget.tasklist.filter.currenttags,
			buttons = tasklist_buttons
		}

		-- Create the wibox
		s.mywibox = awful.wibar({ position = "top", screen = s })

		-- Add widgets to the wibox
		s.mywibox:setup {
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				ui.mylauncher,
				s.mytaglist,
				s.mypromptbox,
			},
			s.mytasklist, -- Middle widget
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				ui.mykeyboardlayout,
				wibox.widget.systray(),
				ui.mytextclock,
				s.mylayoutbox,
			},
		}
	end)
end

error_handling()
set_theme()
set_rules()
set_layouts()
set_global_keybinds()
set_global_mousebinds()
set_monitors()
set_floating_clients()
set_auto_focus()
set_signals()
set_ui()
