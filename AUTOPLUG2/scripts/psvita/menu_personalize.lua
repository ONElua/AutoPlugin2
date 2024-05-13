--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

--dofiles

local VitaNearest_callback = function ()
	VitaNearest()
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
		if os.message(LANGUAGE["RESTART_QUESTION"],1) == 1 then
			change = true
			exit_bye_bye()
		end
	end
end

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
			change = true
			exit_bye_bye()
		end

	end
end

function menu_personalize()

	local menu = {
		{ text = LANGUAGE["MENU_PSVITA_INSTALL_NEAREST"],	desc = LANGUAGE["INSTALLP_DESC_VITANEARESTN"],	        funct = VitaNearest_callback },
	}

	if tai.find("main",path_tai.."AutoBoot.suprx") then
		table.insert(menu, { text = LANGUAGE["MENU_AUTOBOOT_TITLE"],	    desc = LANGUAGE["MENU_EXTRAS_AUTOBOOT_DESC"],	funct = autoboot_callback })
	end

	if tai.find("KERNEL",path_tai.."custom_boot_splash.skprx") then
		table.insert(menu, { text = LANGUAGE["CUSTOMBOOTSPLASH_TITLE"],	    desc = LANGUAGE["MENU_EXTRAS_CONVERT_BOOTSPLASH"],	funct = convertimgsplash_callback })
	end

	if tai.find("main",path_tai.."custom_warning.suprx") then
		table.insert(menu, { text = "Custom Warning",	    desc = LANGUAGE["MENU_EXTRAS_CUSTOM_WARNING"],	funct = customwarning_callback })
	end
	
	if tai.find("main",path_tai.."quickmenuplus.suprx") then
		table.insert(menu, { text = "QuickMenu Plus",	    desc = LANGUAGE["MENU_EXTRAS_QUICKMENU_PLUS"],	funct = customQuickMenu_callback })
	end

	if tai.find("main",path_tai.."TrImpose.suprx") then
		table.insert(menu, { text = "Trimpose",	    desc = LANGUAGE["MENU_EXTRAS_TRANSP_IMPOSE"],	funct = customTransImpose_callback })
	end

	local scroll = newScroll(menu,#menu)

	local xscroll = 10
    while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
        screen.print(480,20,LANGUAGE["MENU_PSVITA_CUSTOMIZE"],1.0,color.white,color.blue,__ACENTER)

        local y = 115
        for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-15,950,45,color.shine:a(65),color.shine:a(40),0x0,color.shine:a(5),21) end

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
        if buttons.accept then

			if back then back:blit(0,0) end
				message_wait()
			os.delay(150)

			menu[scroll.sel].funct()
		end

		vol_mp3()

    end

end
