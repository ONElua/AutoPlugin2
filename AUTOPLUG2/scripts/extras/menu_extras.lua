--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

--Funciones EXTRAS
dofile("scripts/extras/quickmenu.lua")
dofile("scripts/extras/pkgj.lua")
dofile("scripts/extras/customsplash.lua")
dofile("scripts/extras/translate.lua")
dofile("scripts/extras/downloads.lua")
dofile("scripts/psvita/autoboot.lua")

function menu_extras()

	local config_callback = function ()
		downloadtsv_callback()
	end

	local config_callback = function ()
		config_pkgj()
	end

	--local translate_callback = function ()
	--	translate()
	--end
	
	local customTransImpose_callback = function ()

		local text = osk.init(LANGUAGE["TRANSIMPOSE_OSK_TITLE"], 125, 3, __OSK_TYPE_NUMBER, __OSK_MODE_TEXT)
		if not text then return end

		local fp = io.open("ur0:data/trimpose.txt", "wb")
		if fp then
			fp:write(tonumber(text))
			fp:close()

			if back then back:blit(0,0) end
				message_wait(LANGUAGE["TRANSIMPOSE_LEVEL"])
			os.delay(1500)

			if os.message(LANGUAGE["RESTART_QUESTION"],1) == 1 then
				exit_bye_bye()
			end

		end
	end

	local resetconfig_callback = function ()
		if os.message(LANGUAGE["MENU_EXTRAS_QUESTION_RESET_CONFIG"],1) == 1 then
			files.copy("resources/config/config.txt","ur0:tai/")
			tai.load()
		end
	end

	local menu = {
		{ text = LANGUAGE["MENU_EXTRAS_DOWNLOAD_TSV"],		desc = LANGUAGE["MENU_EXTRAS_INSTALL_DESC_DOWNLOAD_TSV"],	funct = downloadtsv_callback },
		{ text = LANGUAGE["MENU_EXTRAS_RESET_CONFIG"],		desc = LANGUAGE["MENU_EXTRAS_INSTALL_DESC_RESET_CONFIG"],	funct = resetconfig_callback },
	}

	if game.exists("PKGJ00000") then
		table.insert(menu, 1, { text = LANGUAGE["MENU_EXTRAS_PKGJ_TITLE"],		desc = LANGUAGE["MENU_EXTRAS_CUSTOM_PKG_CONFIG_DESC"],	funct = config_callback } )
	end



--[[
	idx = tai.find("main", "TrImpose.suprx")
	if idx then
		table.insert(menu, { text = LANGUAGE["MENU_EXTRAS_TRANSP_IMPOSE"],	desc = LANGUAGE["MENU_EXTRAS_TRANSPIMPOSE_DESC"],	funct = customTransImpose_callback } )
	end
]]



	local scroll = newScroll(menu,#menu)

	local xscroll = 10
    while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.fillrect(0,0,960,55,color.black:a(100))
		draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_EXTRAS"],1.2,color.white,0x0,__ACENTER)

        local y = 145
        for i=scroll.ini, scroll.lim do
            if i == scroll.sel then draw.offsetgradrect(5,y-12,950,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
            screen.print(480,y,menu[i].text,1.2,color.white, 0x0, __ACENTER)
			if i == 2 or i == 3 or i == 7 then
				y += 55
			else
				y += 40
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
        if buttons.accept then

			if back then back:blit(0,0) end
				message_wait()
			os.delay(150)

			menu[scroll.sel].funct()
		end

		vol_mp3()

    end

end
