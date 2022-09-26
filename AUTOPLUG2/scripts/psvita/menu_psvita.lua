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
dofile("scripts/psvita/nearest.lua")
dofile("scripts/psvita/hdpatch.lua")

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
end

local VitaNearest_callback = function ()
	VitaNearest()
end

local hd_patch_callback = function ()
	HD_Patch()
end

local autoboot_callback = function ()
	autoboot()
end

local customQuickMenu_callback = function ()
	config_quickmenu()
end

local convertimgsplash_callback = function ()
	customimgsplash()
end

local customwarning_callback = function ()

	local text = osk.init(LANGUAGE["INSTALLP_OSK_TITLE"], LANGUAGE["INSTALLP_OSK_TEXT"])
	if not text then return end

	local fp = io.open(path_tai.."custom_warning.txt", "wb")
	if fp then
		fp:write(string.char(0xFF)..string.char(0xFE))
		fp:write(os.toucs2(text))
		fp:close()
		files.delete("ux0:tai/custom_warning.txt")
		files.delete("uma0:tai/custom_warning.txt")
		--if os.message(LANGUAGE["RESTART_QUESTION"],1) == 1 then
		--	exit_bye_bye()
		--end
	end
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
		{ text = LANGUAGE["MENU_PSVITA_HD_PATCH"],          desc = LANGUAGE["MENU_PSVITA_HD_PATCH_DESC"],	        funct = hd_patch_callback },
		--{ text = LANGUAGE["MENU_PSVITA_INSTALL_NEAREST"],   desc = LANGUAGE["INSTALLP_DESC_VITANEARESTN"],			funct = VitaNearest_callback },
	}

	local idx = tai.find("main", "AutoBoot.suprx")
	if idx then
		table.insert(menu, { text = LANGUAGE["MENU_AUTOBOOT_TITLE"],	desc = LANGUAGE["MENU_EXTRAS_AUTOBOOT_DESC"],	funct = autoboot_callback } )
	end

	local idx = tai.find("KERNEL", "custom_boot_splash.skprx")
	if idx then
		table.insert(menu, { text = LANGUAGE["MENU_EXTRAS_CONVERT_BOOTSPLASH"],	desc = LANGUAGE["MENU_EXTRAS_CUSTOMBOOTSPLASH_DESC"],	funct = convertimgsplash_callback } )
	end

	idx = tai.find("main", "custom_warning.suprx")
	if idx then
		table.insert(menu, { text = LANGUAGE["MENU_EXTRAS_CUSTOM_WARNING"],	desc = LANGUAGE["MENU_EXTRAS_CUSTOMWARNING_DESC"],	funct = customwarning_callback } )
	end

	idx = tai.find("main", "quickmenuplus.suprx")
	if idx then
		table.insert(menu, { text = LANGUAGE["MENU_EXTRAS_QUICKMENU_PLUS"],	desc = LANGUAGE["MENU_EXTRAS_QUICKMENU_DESC"],	funct = customQuickMenu_callback } )
	end

	local scroll = newScroll(menu,#menu)
	local xscroll = 10

	buttons.interval(10,6)
	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.fillrect(0,0,960,55,color.black:a(100))
		draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_PSVITA_TITLE"],1.2,color.white,0x0,__ACENTER)

		local y = 115
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-12,950,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
			screen.print(480,y,menu[i].text,1.2,color.white,0x0,__ACENTER)
			
			if i == 3 then
				y += 65
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
		if buttons.accept then menu[scroll.sel].funct()	end

		vol_mp3()

	end
end
