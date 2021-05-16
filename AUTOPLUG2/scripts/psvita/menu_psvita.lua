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
dofile("scripts/psvita/p4golden.lua")
dofile("scripts/psvita/catherine.lua")
dofile("scripts/psvita/nearest.lua")

Catherine = false
if game.exists("PCSG01179") then Catherine = true end

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
	plugins_online2()
end

local VitaNearest_callback = function ()
	VitaNearest()
end

local p4_callback = function ()
	P4Golden_HD()
end

local catherine_callback = function ()
	Catherine_HD()
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
		{ text = LANGUAGE["MENU_PSVITA_INSTALL_NEAREST"],   desc = LANGUAGE["INSTALLP_DESC_VITANEARESTN"],			funct = VitaNearest_callback },
	}

	if P4Golden then
		table.insert(menu, { text = LANGUAGE["MENU_PSVITA_INSTALL_P4G_HD"],	desc = LANGUAGE["MENU_PSVITA_INSTALL_P4G_HD_DESC"],		funct = p4_callback } )
	end
	if Catherine then
		table.insert(menu, { text = LANGUAGE["MENU_PSVITA_INSTALL_CATHERINE_HD"],	desc = LANGUAGE["MENU_PSVITA_INSTALL_CATHERINE_HD_DESC"],	funct = catherine_callback } )
	end

	if tonumber(cont_global:get()) == 0 then
		table.insert(menu, { text = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS"],	desc = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS_DESC"],	funct = onlineplugins_callback } )
	else
		table.insert(menu, { text = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS"].." ( "..tostring(cont_global:get()).." )",	desc = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS_DESC"],	funct = onlineplugins_callback } )
	end

	local scroll = newScroll(menu,#menu)
	local xscroll = 10

	buttons.interval(10,6)
	while true do
	
		menu = {
			{ text = LANGUAGE["MENU_PSVITA_INSTALL_PLUGINS"],	desc = LANGUAGE["MENU_PSVITA_INSTALL_PLUGINS_DESC"],	funct = installp_callback },
			{ text = LANGUAGE["MENU_PSVITA_UNINSTALL_PLUGINS"],	desc = LANGUAGE["MENU_PSVITA_UNINSTALL_PLUGINS_DESC"],	funct = uinstallp_callback },
			{ text = LANGUAGE["MENU_PSVITA_INSTALL_SD2VITA"],	desc = LANGUAGE["MENU_PSVITA_INSTALL_SD2VITA_DESC"],	funct = sd2vita_callback },
			{ text = LANGUAGE["MENU_PSVITA_INSTALL_NEAREST"],   desc = LANGUAGE["INSTALLP_DESC_VITANEARESTN"],			funct = VitaNearest_callback },
		}
		
		if P4Golden then
			table.insert(menu, { text = LANGUAGE["MENU_PSVITA_INSTALL_P4G_HD"],	desc = LANGUAGE["MENU_PSVITA_INSTALL_P4G_HD_DESC"],		funct = p4_callback } )
		end
		if Catherine then
			table.insert(menu, { text = LANGUAGE["MENU_PSVITA_INSTALL_CATHERINE_HD"],	desc = LANGUAGE["MENU_PSVITA_INSTALL_CATHERINE_HD_DESC"],	funct = catherine_callback } )
		end

		if tonumber(cont_global:get()) == 0 then
			table.insert(menu, { text = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS"],	desc = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS_DESC"],	funct = onlineplugins_callback } )
		else
			table.insert(menu, { text = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS"].." ( "..tostring(cont_global:get()).." )",	desc = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS_DESC"],	funct = onlineplugins_callback } )
		end

		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_PSVITA_TITLE"],1.2,color.white,0x0,__ACENTER)

		local y = 135
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-12,950,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
			screen.print(480,y,menu[i].text,1.2,color.white,0x0,__ACENTER)
			
			if i == 3 or i == #menu-1 then
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
