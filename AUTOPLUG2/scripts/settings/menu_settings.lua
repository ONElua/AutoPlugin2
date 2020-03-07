--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

--Funciones Settings
dofile("scripts/settings/lang_online.lua")
dofile("scripts/settings/change_lang.lua")
dofile("scripts/settings/change_font.lua")

function menu_settings()

	local lang_online_callback = function ()
		lang_online()
	end

	local autoupdate_callback = function ()
		local tmp = __UPDATE
		if __UPDATE == 1 then
			_update = LANGUAGE["NO"]
			__UPDATE = 0
		else
			_update = LANGUAGE["YES"]
			__UPDATE = 1
		end

		if __UPDATE != tmp then write_config() os.delay(150) end
	end

	local change_lang_callback = function ()
		change_lang()
	end

	local change_font_callback = function ()
		change_font()
	end

	local menu = {
		{ text = LANGUAGE["MENU_SETTINGS_LANG_ONLINE"],			desc = LANGUAGE["MENU_SETTINGS_LANG_ONLINE_DESC"],			funct = lang_online_callback },
		{ text = LANGUAGE["MENU_SETTINGS_ENABLE_AUTOUPDATE"].._update,	desc = LANGUAGE["MENU_SETTINGS_AUTOUPDATE_DESC"],	funct = autoupdate_callback },
		{ text = LANGUAGE["MENU_SETTINGS_CHANGE_LANGUAGE"],		desc = LANGUAGE["MENU_SETTINGS_CHANGE_LANGUAGE_DESC"],		funct = change_lang_callback },
		{ text = LANGUAGE["MENU_SETTINGS_CHANGE_FONT"],			desc = LANGUAGE["MENU_SETTINGS_CHANGE_FONT_DESC"],			funct = change_font_callback },
	}
	local scroll = newScroll(menu,#menu)

	local xscroll = 10
	while true do
		--Reload Menu for LANGUAGE
		menu = {
			{ text = LANGUAGE["MENU_SETTINGS_LANG_ONLINE"],			desc = LANGUAGE["MENU_SETTINGS_LANG_ONLINE_DESC"],			funct = lang_online_callback },
			{ text = LANGUAGE["MENU_SETTINGS_ENABLE_AUTOUPDATE"].._update,	desc = LANGUAGE["MENU_SETTINGS_AUTOUPDATE_DESC"],	funct = autoupdate_callback },
			{ text = LANGUAGE["MENU_SETTINGS_CHANGE_LANGUAGE"],		desc = LANGUAGE["MENU_SETTINGS_CHANGE_LANGUAGE_DESC"],		funct = change_lang_callback },
			{ text = LANGUAGE["MENU_SETTINGS_CHANGE_FONT"],			desc = LANGUAGE["MENU_SETTINGS_CHANGE_FONT_DESC"],			funct = change_font_callback },
		}

		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_SETTINGS"],1.2,color.white,0x0,__ACENTER)

		local y = 145
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-12,950,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
			screen.print(480,y,menu[i].text,1.2,color.white,0x0,__ACENTER)
			y += 45
		end

		if screen.textwidth(menu[scroll.sel].desc) > 925 then
			xscroll = screen.print(xscroll, 520, menu[scroll.sel].desc,1,color.white,color.blue,__SLEFT,935)
		else
			screen.print(480, 520, menu[scroll.sel].desc,1,color.white,color.blue,__ACENTER)
		end

		screen.flip()

		--Controls
		if buttons.left or buttons.right then xscroll = 10 end

		if buttons.up or buttons.analogly < -60 then
			if scroll:up() then xscroll = 10 end
		end
		if buttons.down or buttons.analogly > 60 then
			if scroll:down() then xscroll = 10 end
		end

		if buttons.cancel then break end
		if buttons.accept then menu[scroll.sel].funct() end

	end
end

