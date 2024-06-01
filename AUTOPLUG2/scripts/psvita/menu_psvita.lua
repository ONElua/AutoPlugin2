--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

--Plugins!!!
dofile("plugins/plugins.lua")
if #plugins > 0 then table.sort(plugins, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end

--Funciones PSVITA
dofile("scripts/psvita/sd2vita.lua")
dofile("scripts/psvita/pmanager.lua")
dofile("scripts/psvita/autoplugin.lua")
dofile("scripts/psvita/plugins_online.lua")
dofile("scripts/extras/nearest.lua")
dofile("scripts/psvita/hdpatch.lua")
dofile("scripts/psvita/info.lua")
dofile("scripts/psvita/menu_personalize.lua")

local sd2vita_callback = function ()
	sd2vita()
end

local installp_callback = function ()
	autoplugin()
end

local uinstallp_callback = function ()
	pluginsmanager()
end

local onlineplugins_callback = function ()
	psvita_plugins_online()
	--Main Cycle
	dofile("menu.lua")
end

local miscellaneous_callback = function ()
	Misc_Plugins()
end

function menu_ps()

	if tai.find("KERNEL", "storagemgr.skprx") then
		LANGUAGE["MENU_PSVITA_INSTALL_SD2VITA"] 		= LANGUAGE["MENU_PSVITA_CONFIGURE_SD2VITA"]
		LANGUAGE["MENU_PSVITA_INSTALL_SD2VITA_DESC"] 	= LANGUAGE["MENU_PSVITA_CONFIG_SD2VITA_DESC"]
	end

	local menu = {
		{ text = LANGUAGE["MENU_PSVITA_INSTALL_PLUGINS"],	desc = LANGUAGE["MENU_PSVITA_INSTALL_PLUGINS_DESC"],	funct = installp_callback },
		{ text = LANGUAGE["MENU_PSVITA_UNINSTALL_PLUGINS"],	desc = LANGUAGE["MENU_PSVITA_UNINSTALL_PLUGINS_DESC"],	funct = uinstallp_callback },
		{ text = LANGUAGE["MENU_PSVITA_INSTALL_SD2VITA"],	desc = LANGUAGE["MENU_PSVITA_INSTALL_SD2VITA_DESC"],	funct = sd2vita_callback },
		{ text = LANGUAGE["MENU_PSVITA_MISCELLANEOUS"],     desc = LANGUAGE["MENU_PSVITA_MISCELLANEOUS_DESC"],      funct = miscellaneous_callback },
		{ text = LANGUAGE["MENU_PSVITA_CUSTOMIZE"],         desc = LANGUAGE["MENU_PSVITA_CUSTOMIZE_DESC"],	        funct = menu_personalize },
	}

	if tonumber(cont_global:get()) > 0 and yes_update and tonumber(yes_update:get()) == 3 then
		table.insert(menu, { text = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS"].." ( "..tonumber(cont_global:get()).." )",	desc = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS_DESC"],	funct = onlineplugins_callback } )
	end

	local scroll = newScroll(menu,#menu)
	local xscroll = 10

	buttons.interval(10,6)
	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_PSVITA_TITLE"],1.0,color.white,color.blue,__ACENTER)

		local y = 115
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-15,950,45,color.shine:a(65),color.shine:a(40),0x0,color.shine:a(5),21) end
			--	tam = 1.2
			--else tam = 1.0 end

			screen.print(480,y,menu[i].text,1.0,color.white,color.blue,__ACENTER)--color.white,0x0,__ACENTER)
			
			if i == 3 then
				y += 70
			else
				y += 45
			end
		end

		if screen.textwidth(menu[scroll.sel].desc) > 925 then
			xscroll = screen.print(xscroll, 520, menu[scroll.sel].desc,1,color.white,color.blue,__SLEFT,935)
		else
			screen.print(480, 520, menu[scroll.sel].desc,1,color.white,color.blue,__ACENTER)
		end
		--screen.print(05,60,"D: "..tostring(THIDS:geterror()),0.9)
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

		vol_mp3()

	end
end
