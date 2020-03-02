--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

local psvita_callback = function ()
    menu_ps()
end

local psp_callback = function ()
	menu_psp()
end

local extras_callback = function ()
	menu_extras()
end

local settings_callback = function ()
	menu_settings()
end

local exit_callback = function ()
    if change then
		os.message(LANGUAGE["STRING_PSVITA_RESTART"])
		os.delay(250)
		buttons.homepopup(1)
		power.restart()
	end
	os.exit()
end

change = false
function menu_gral()

	local menu = {
		{ text = LANGUAGE["MENU_PSVITA"],	funct = psvita_callback },
		{ text = LANGUAGE["MENU_PSP"],		funct = psp_callback },
		{ text = LANGUAGE["MENU_EXTRAS"],	funct = extras_callback },
		{ text = LANGUAGE["MENU_SETTINGS"],	funct = settings_callback },
		{ text = LANGUAGE["MENU_EXIT"],		funct = exit_callback }
	}
	local scroll = newScroll(menu,#menu)

	buttons.interval(10,6)
	while true do
	
		menu = {
			{ text = LANGUAGE["MENU_PSVITA"],	funct = psvita_callback },
			{ text = LANGUAGE["MENU_PSP"],		funct = psp_callback },
			{ text = LANGUAGE["MENU_EXTRAS"],	funct = extras_callback },
			{ text = LANGUAGE["MENU_SETTINGS"],	funct = settings_callback },
			{ text = LANGUAGE["MENU_EXIT"],		funct = exit_callback }
		}

		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_TITLE"],1.2,color.white,0x0,__ACENTER)

		local y = 145
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-12,950,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
			screen.print(480,y,menu[i].text,1.2,color.white,0x0,__ACENTER)
			y += 45
		end

		screen.flip()

		--Controls
		if buttons.up or buttons.analogly < -60 then scroll:up() end
		if buttons.down or buttons.analogly > 60 then scroll:down() end

		--if buttons.cancel then menu[5].funct() end
		if buttons.accept then menu[scroll.sel].funct() end

	end

end

menu_gral()
