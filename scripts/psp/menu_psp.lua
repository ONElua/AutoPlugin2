--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

--Funciones PSP
dofile("plugins/plugins_psp.lua")
if #pluginsP > 0 then table.sort(pluginsP, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end
if #psp_plugins > 0 then table.sort(psp_plugins, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end

dofile("scripts/psp/npdrm.lua")
dofile("scripts/psp/pspctrls.lua")
dofile("scripts/psp/pluginspsp.lua")
dofile("scripts/psp/plugins_psp_online.lua")
dofile("scripts/psp/plugins_psp_manager.lua")

function menu_psp()

	local npdrm_callback = function ()
		npdrm_free()
	end

	local psp_ctrls_callback = function ()
		psp_ctrls()
	end

	local psp_plugins_callback = function ()
		pluginsPSP()
	end

	local psp_plugins_manager_callback = function ()
		psp_plugins_manager()
	end

	local onlinepluginspsp_callback = function ()
		if back then back:blit(0,0) end
			message_wait(LANGUAGE["UPDATER_DOWNLOADING"])
		os.delay(750)
		psp_plugins_online()
	end

	local menu = {
		{ text = LANGUAGE["MENU_PSP_INSTALL_PLUGINS"],			desc = LANGUAGE["MENU_PSP_PLUGINS_DESC"],	funct = psp_plugins_callback },
		{ text = LANGUAGE["UNINSTALLP_TITLE"],					desc = LANGUAGE["MENU_PSVITA_UNINSTALL_PLUGINS_DESC"], funct = psp_plugins_manager_callback },
		{ text = LANGUAGE["MENU_PSP_INSTALL_NPDRMFREE"],		desc = LANGUAGE["MENU_PSP_NPDRMFREE_DESC"],	funct = npdrm_callback },
		{ text = LANGUAGE["MENU_PSP_INSTALL_REMASTERED_CTRLS"],	desc = LANGUAGE["MENU_PSP_PSPCTRLS_DESC"],	funct = psp_ctrls_callback },
		{ text = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS"],	desc = LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS_DESC"], funct = onlinepluginspsp_callback },
	}
	local scroll = newScroll(menu,#menu)

	local xscroll = 10
	while true do

		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_PSP_TITLE"],1.0,color.white,color.blue,__ACENTER)

		local y = 115
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-15,950,45,color.shine:a(65),color.shine:a(40),0x0,color.shine:a(5),21) end
			--	tam = 1.4
			--else tam = 1.2 end

			screen.print(480,y,menu[i].text,1.0,color.white,color.blue,__ACENTER)
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

		vol_mp3()

	end
end

