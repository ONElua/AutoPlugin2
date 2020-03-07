--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

--Funciones EXTRAS
dofile("scripts/extras/pkgj.lua")
dofile("scripts/extras/customsplash.lua")
dofile("scripts/extras/translate.lua")
files.mkdir("ux0:data/AUTOPLUGIN2/vpks/")

function download_install(url,name)
	if back2 then back2:blit(0,0) end
		message_wait()
	os.delay(250)
	files.delete("tmp")
	local onNetGetFileOld = onNetGetFile
	onNetGetFile = nil
	http.download(url,"tmp")
	onNetGetFile = onNetGetFileOld

	if files.exists("tmp") then
		local objh = html.parsefile("tmp")
		if objh then

			local links = objh:findall(html.TAG_A)
			if links then
				--os.message("Links "..#links)
				for i=1,#links do
					if links[i].href then
						if links[i].href:find(name,1,true) then
							--os.message(links[i].href)
							onNetGetFile = onNetGetFileOld
							__file = files.nopath(files.nofile(links[i].href))..name
							__file = string.gsub(__file,"/","  ")
							http.download("https://github.com"..links[i].href,"ux0:data/AUTOPLUGIN2/vpks/"..name)
							if files.exists("ux0:data/AUTOPLUGIN2/vpks/"..name) then
								game.install("ux0:data/AUTOPLUGIN2/vpks/"..name,false)
								break
							end
						end
					end
				end
			else
				os.message(LANGUAGE["LANG_ONLINE_FAIL_CONEXION"])
			end
		else
			os.message(LANGUAGE["UPDATE_WIFI_IS_ON"])
		end
	else
		os.message(LANGUAGE["UPDATE_WIFI_IS_ON"])
	end
	__file = ""
end

function menu_extras()

	local convertimgsplash_callback = function ()
		if back then back:blit(0,0) end
			message_wait()
		os.delay(150)

		customimgsplash()
	end

	local config_callback = function ()
		config_pkgj()
	end

	local customwarning_callback = function ()
		local pathCW = "ur0:tai/"
		if files.exists("ux0:tai/custom_warning.txt") then pathCW = "ux0:tai/" end

		local text = osk.init(LANGUAGE["INSTALLP_OSK_TITLE"], LANGUAGE["INSTALLP_OSK_TEXT"])
		if not text then return end

		local fp = io.open(pathCW.."custom_warning.txt", "wb")
		if fp then
			fp:write(string.char(0xFF)..string.char(0xFE))
			fp:write(os.toucs2(text))
			fp:close()

			if os.message(LANGUAGE["RESTART_QUESTION"],1) == 1 then
				if back then back:blit(0,0) end
					message_wait(LANGUAGE["STRING_PSVITA_RESTART"])
				os.delay(1500)
				buttons.homepopup(1)
				power.restart()
			end

		end
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
				if back then back:blit(0,0) end
					message_wait(LANGUAGE["STRING_PSVITA_RESTART"])
				os.delay(1500)
				buttons.homepopup(1)
				power.restart()
			end

		end
	end

	local itls_callback = function ()
		download_install("https://github.com/SKGleba/iTLS-Enso/releases/latest/", "iTLS-Enso.vpk")
		files.delete("ux0:data/AUTOPLUGIN2/vpks/")
	end

	local batteryfixer_callback = function ()
		download_install("https://github.com/SKGleba/PSP2-batteryFixer/releases/latest/", "batteryFixer.vpk")
		files.delete("ux0:data/AUTOPLUGIN2/vpks/")
	end

	--Init load configs
	loc = 1
	tai.load()
	if tai[__UR0].exist then loc = 2 end
	local menu = {
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_ITLSENSO"],	desc = LANGUAGE["MENU_EXTRAS_INSTALL_ITLSENSO_DESC"],	funct = itls_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_BATTFIX"],	desc = LANGUAGE["MENU_EXTRAS_INSTALL_DESC_BATTFIX"],	funct = batteryfixer_callback },
	}

	if game.exists("PKGJ00000") then
		table.insert(menu, 1, { text = LANGUAGE["MENU_EXTRAS_PKGJ_TITLE"],		desc = LANGUAGE["MENU_EXTRAS_CUSTOM_PKG_CONFIG_DESC"],	funct = config_callback } )
	end

	local idx = tai.find(loc, "KERNEL", "custom_boot_splash.skprx")
	if idx then
		table.insert(menu, { text = LANGUAGE["MENU_EXTRAS_CONVERT_BOOTSPLASH"],	desc = LANGUAGE["MENU_EXTRAS_CUSTOMBOOTSPLASH_DESC"],	funct = convertimgsplash_callback } )
	end

	idx = tai.find(loc, "main", "custom_warning.suprx")
	if idx then
		table.insert(menu, { text = LANGUAGE["MENU_EXTRAS_CUSTOM_WARNING"],	desc = LANGUAGE["MENU_EXTRAS_CUSTOMWARNING_DESC"],	funct = customwarning_callback } )
	end

	idx = tai.find(loc, "main", "TrImpose.suprx")
	if idx then
		table.insert(menu, { text = LANGUAGE["MENU_EXTRAS_TRANSP_IMPOSE"],	desc = LANGUAGE["MENU_EXTRAS_TRANSPIMPOSE_DESC"],	funct = customTransImpose_callback } )
	end

	--table.insert(menu, { text = LANGUAGE["MENU_EXTRAS_TRANSLATE"],	desc = LANGUAGE["MENU_EXTRAS_TRANSLATE_DESC"],	funct = translate_callback} )

	local scroll = newScroll(menu,#menu)

	local xscroll = 10
    while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_EXTRAS"],1.2,color.white,0x0,__ACENTER)

        local y = 145
        for i=scroll.ini, scroll.lim do
            if i == scroll.sel then draw.offsetgradrect(5,y-12,950,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
            screen.print(480,y,menu[i].text,1.2,color.white, 0x0, __ACENTER)
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

    end

end
