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
dofile("scripts/extras/autoboot.lua")

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

	local resetconfig_callback = function ()
		if os.message(LANGUAGE["MENU_EXTRAS_QUESTION_RESET_CONFIG"],1) == 1 then
			files.copy("resources/config/config.txt","ur0:tai/")
			tai.load()
		end
	end

	local menu = {
		{ text = LANGUAGE["MENU_EXTRAS_DOWNLOAD_TSV"],	desc = LANGUAGE["MENU_EXTRAS_INSTALL_DESC_DOWNLOAD_TSV"],	funct = downloadtsv_callback },
		{ text = LANGUAGE["MENU_EXTRAS_RESET_CONFIG"],	desc = LANGUAGE["MENU_EXTRAS_INSTALL_DESC_RESET_CONFIG"],	funct = resetconfig_callback },
	}

	if game.exists("PKGJ00000") then
		table.insert(menu, 1, { text = LANGUAGE["MENU_EXTRAS_PKGJ_TITLE"],		desc = LANGUAGE["MENU_EXTRAS_CUSTOM_PKG_CONFIG_DESC"],	funct = config_callback } )
	end

	local scroll = newScroll(menu,#menu)

	local xscroll = 10
    while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end
		if math.minmax(tonumber(os.date("%d%m")),2012,2512) == tonumber(os.date("%d%m")) then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_EXTRAS"],1.2,color.white,0x0,__ACENTER)

        local y = 145
        for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-15,950,45,color.shine:a(65),color.shine:a(40),0x0,color.shine:a(5),21)
				tam = 1.4
			else tam = 1.2 end

			screen.print(480,y,menu[i].text,tam,color.white,0x0,__ACENTER)

			if i == 2 or i == 3 or i == 7 then
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
