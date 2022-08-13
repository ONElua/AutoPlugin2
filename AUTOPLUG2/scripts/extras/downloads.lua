--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

files.mkdir("ux0:data/AUTOPLUGIN2/vpks/")

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
						if links[i].href:find(name,1,true) then
							--os.message(links[i].href)
							onNetGetFile = onNetGetFileOld
							__file = files.nopath(files.nofile(links[i].href))..name
							__file = string.gsub(__file,"/","  ")
							local res = http.download("https://github.com"..links[i].href,"ux0:data/AUTOPLUGIN2/vpks/"..name)
							if res and res.success and files.exists("ux0:data/AUTOPLUGIN2/vpks/"..name) then
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

	--Clean
	files.delete("ux0:data/AUTOPLUGIN2/vpks/")
	files.delete("tmp")
	__file = ""

end

function downloads()

	local itls_callback = function ()
		download_install("https://github.com/SKGleba/iTLS-Enso/releases/latest/", "iTLS-Enso.vpk")
	end

	local vitashell_callback = function ()
		download_install("https://github.com/TheOfficialFloW/VitaShell/releases/latest/", "VitaShell.vpk")
	end

	local vitashell_yoti_callback = function ()
		download_install("https://github.com/RealYoti/VitaShell/releases/latest/", "VitaShell.vpk")
	end

	local ShaRKF00D_callback = function ()
		download_install("https://github.com/OsirizX/ShaRKF00D/releases/latest/", "ShaRKF00D.vpk")
	end

	local batteryfixer_callback = function ()
		download_install("https://github.com/SKGleba/PSP2-batteryFixer/releases/latest/", "batteryFixer.vpk")
	end

	local yamt_callback = function ()
		download_install("https://github.com/SKGleba/yamt-vita/releases/latest/", "yamt.vpk")
	end

	local menu = {
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_ITLSENSO"],	desc = LANGUAGE["MENU_EXTRAS_INSTALL_ITLSENSO_DESC"],		funct = itls_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_VITASHELL"],	desc = LANGUAGE["MENU_EXTRAS_INSTALL_VITASHELL_DESC"],		funct = vitashell_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_VITASHELL2"],desc = LANGUAGE["MENU_EXTRAS_INSTALL_VITASHELL2_DESC"],		funct = vitashell_yoti_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_SHARKF00D"],	desc = LANGUAGE["MENU_EXTRAS_INSTALL_SHARKF00D_DESC"],		funct = ShaRKF00D_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_BATTFIX"],	desc = LANGUAGE["MENU_EXTRAS_INSTALL_DESC_BATTFIX"],		funct = batteryfixer_callback },
		{ text = LANGUAGE["MENU_EXTRAS_INSTALL_YAMT"],	    desc = LANGUAGE["MENU_EXTRAS_INSTALL_YAMT_DESC"],		    funct = yamt_callback },
	}

	local scroll = newScroll(menu,#menu)

	local xscroll = 10
    while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_DOWNLOADS"],1.2,color.white,0x0,__ACENTER)

        local y = 145
        for i=scroll.ini, scroll.lim do
            if i == scroll.sel then draw.offsetgradrect(5,y-12,950,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
            screen.print(480,y,menu[i].text,1.2,color.white, 0x0, __ACENTER)
			y += 40
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