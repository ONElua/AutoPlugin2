--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

files.mkdir("ux0:data/AUTOPLUGIN2/vpks/")

function get_icon0(obj)

	local vpk = files.scan(obj,1)
	if vpk and #vpk > 0 then
		for i=1,#vpk do
			local name = vpk[i].name:lower()
			if name == "sce_sys/icon0.png" then return game.geticon0(obj, vpk[i].pos) end
		end
    end
	return nil
end

function download_install(url,name)

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
						
						if links[i].href:find("releases/tag/",1,true) then
							--os.message(links[i].href)
							__file = name.." "..files.nopath(links[i].href)
							--os.message(__file)
							local res = http.download(url.."/releases/download/"..files.nopath(links[i].href).."/"..name,"ux0:data/AUTOPLUGIN2/vpks/"..name)
							if res.headers and res.headers.status_code == 200 and files.exists("ux0:data/AUTOPLUGIN2/vpks/"..name) then
								__icon = get_icon0("ux0:data/AUTOPLUGIN2/vpks/"..name)
								if __icon then __icon:center() end						
								game.install("ux0:data/AUTOPLUGIN2/vpks/"..name,false)
								__icon = nil
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

	--Clean
	files.delete("ux0:data/AUTOPLUGIN2/vpks/")
	files.delete("tmp")
	__file = ""

end

function downloads()

	local itls_callback = function ()
		download_install("https://github.com/SKGleba/iTLS-Enso", "iTLS-Enso.vpk")
	end

	local vitashell_callback = function ()
		download_install("https://github.com/TheOfficialFloW/VitaShell", "VitaShell.vpk")
	end

	local vitashell_yoti_callback = function ()
		download_install("https://github.com/RealYoti/VitaShell/", "VitaShell.vpk")
	end

	local ShaRKF00D_callback = function ()
		download_install("https://github.com/OsirizX/ShaRKF00D", "ShaRKF00D.vpk")
	end

	local SHARKB33D_callback = function ()
		download_install("https://github.com/Rinnegatamante/ShaRKBR33D", "ShaRKBR33D.vpk")
	end

	local batteryfixer_callback = function ()
		download_install("https://github.com/SKGleba/PSP2-batteryFixer", "batteryFixer.vpk")
	end

	local yamt_callback = function ()
		download_install("https://github.com/SKGleba/yamt-vita", "yamt.vpk")
	end

	local onemenu_callback = function ()
		download_install("https://github.com/ONElua/ONEMenu-for-PSVita", "ONEMenuVita.vpk")
	end

	local psp2wpp_reload_callback = function ()
		download_install("https://github.com/Princess-of-Sleeping/psp2wpp-reload/", "psp2wpp_reload.vpk")
	end

	local menu = {
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_VITASHELL"],	 desc = LANGUAGE["MENU_EXTRAS_INSTALL_VITASHELL_DESC"],		funct = vitashell_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_VITASHELL2"], desc = LANGUAGE["MENU_EXTRAS_INSTALL_VITASHELL2_DESC"],	funct = vitashell_yoti_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_ONEMENU"],    desc = LANGUAGE["MENU_EXTRAS_INSTALL_ONEMENU_DESC"],		funct = onemenu_callback },
--		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_SHARKF00D"],	 desc = LANGUAGE["MENU_EXTRAS_INSTALL_SHARKF00D_DESC"],		funct = ShaRKF00D_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_SHARKB33D"],	 desc = LANGUAGE["MENU_EXTRAS_INSTALL_SHARKB33D_DESC"],		funct = SHARKB33D_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_ITLSENSO"],	 desc = LANGUAGE["MENU_EXTRAS_INSTALL_ITLSENSO_DESC"],		funct = itls_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_BATTFIX"],	 desc = LANGUAGE["MENU_EXTRAS_INSTALL_DESC_BATTFIX"],		funct = batteryfixer_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_YAMT"],	     desc = LANGUAGE["MENU_EXTRAS_INSTALL_YAMT_DESC"],		    funct = yamt_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_WAVERELOAD"], desc = LANGUAGE["MENU_EXTRAS_INSTALL_WAVERELOAD_DESC"],    funct = psp2wpp_reload_callback },
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
        screen.print(480,20,LANGUAGE["MENU_DOWNLOADS"],1.0,color.white,color.blue,__ACENTER)

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
        if buttons.accept then

			if back then back:blit(0,0) end
				message_wait()
			os.delay(150)

			menu[scroll.sel].funct()
		end

		vol_mp3()

    end
	
end
