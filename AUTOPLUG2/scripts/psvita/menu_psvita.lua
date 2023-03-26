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

--[[
local fp = io.open("db.json", "w+")
fp:write("{\n")
fp:write('	"plugins": [\n')
for key,value in pairs(plugins) do
	fp:write("		{\n")
	if type(value) == "table" then
		for s,t in pairs(value) do
			if s == "crc" then
				fp:write(string.format('			"%s": "0x%x",\n', tostring(s),tonumber(t)) )
			elseif s == "link" then
				fp:write(string.format('			"readme": "%s",\n',tostring(t)) )
			elseif s == "desc" then
				fp:write(string.format('			"%s": "LANGUAGE["%s"]",\n', tostring(s),tostring(value.KEY)))
			else
				fp:write(string.format('			"%s": "%s",\n', tostring(s),tostring(t)) )
			end
		end
		fp:write("		},\n")
	end
end
fp:write('	]\n')
fp:write('}')
fp:close()

error("usb")]]

--Funciones PSVITA
dofile("scripts/psvita/sd2vita.lua")
dofile("scripts/psvita/pmanager.lua")
dofile("scripts/psvita/autoplugin.lua")
dofile("scripts/psvita/plugins_online.lua")
dofile("scripts/extras/downloads.lua")
dofile("scripts/extras/nearest.lua")
dofile("scripts/psvita/hdpatch.lua")
dofile("scripts/psvita/info.lua")

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

local downloads_callback = function ()
	downloads()
end

local hd_patch_callback = function ()
	HD_Patch()
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
		{ text = LANGUAGE["MENU_DOWNLOADS"],                desc = LANGUAGE["MENU_EXTRAS_DOWNLOADS_DESC"],          funct = downloads_callback },
		{ text = LANGUAGE["MENU_PSVITA_HD_PATCH"],          desc = LANGUAGE["MENU_PSVITA_HD_PATCH_DESC"],	        funct = hd_patch_callback },
	}

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
		screen.print(480,20,LANGUAGE["MENU_PSVITA_TITLE"],1.2,color.white,0x0,__ACENTER)

		local y = 115
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-15,950,45,color.shine:a(65),color.shine:a(40),0x0,color.shine:a(5),21)
				tam = 1.4
			else tam = 1.2 end

			screen.print(480,y,menu[i].text,tam,color.white,0x0,__ACENTER)
			
			if i == 3 then
				y += 70
			else
				y += 50
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
