--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

dofile("addons/wave.lua")
wave = newWave()
wave:begin("imgs/back1.png")

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
	exit_bye_bye()
end

function menu_gral()

	local menu = {
		{ text = LANGUAGE["MENU_PSVITA"],	funct = psvita_callback },
		{ text = LANGUAGE["MENU_PSP"],		funct = psp_callback },
		{ text = LANGUAGE["MENU_EXTRAS"],   funct = extras_callback },
		{ text = LANGUAGE["MENU_SETTINGS"],	funct = settings_callback },
		{ text = LANGUAGE["MENU_EXIT"],		funct = exit_callback }
	}
	local scroll = newScroll(menu,#menu)

	buttons.interval(10,6)
	while true do
		power.tick(0)
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		if tonumber(cont_global:get()) > 0 and tonumber(yes_update:get()) == 2 then
			if back then back:blit(0,0) end
				message_wait(LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS_DESC"])
			os.delay(750)
			cont_global:set(tonumber(0))
			psvita_plugins_online()
		end

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.shine:a(85),color.shine:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_TITLE"],1.2,color.white,0x0,__ACENTER)

		local y = 115
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-15,950,45,color.shine:a(65),color.shine:a(40),0x0,color.shine:a(5),21)
				tam = 1.4
			else tam = 1.2 end

			screen.print(480,y,menu[i].text,tam,color.white,0x0,__ACENTER)
			y += 50
		end

		screen.flip()

		--Controls
		if buttons.up or buttons.analogly < -60 then scroll:up() end
		if buttons.down or buttons.analogly > 60 then scroll:down() end

		if buttons.accept then menu[scroll.sel].funct() end

		vol_mp3()

	end

end

menu_gral()
