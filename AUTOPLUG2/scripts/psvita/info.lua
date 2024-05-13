--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]


function plugin_info(obj)

	local onNetGetFileOld = onNetGetFile
	onNetGetFile = nil

	local SCREENSHOT,img = nil,nil
	if obj.id then
		SCREENSHOT = string.format("https://raw.githubusercontent.com/%s/%s/master/screenshots/%s", APP_REPO, APP_PROJECT, obj.id)
		img = image.load(screenshots..obj.id)
		if not img then
			local res = http.download(SCREENSHOT, screenshots..obj.id)
			if res.headers and res.headers.status_code == 200 and files.exists(screenshots..obj.id) then
				img = image.load(screenshots..obj.id)
				else files.delete(screenshots..obj.id)
			end
		end
		if img then
			img:resize(575,340)
			img:setfilter(__IMG_FILTER_LINEAR, __IMG_FILTER_LINEAR)
		end
	end

	if obj.link and not obj.status then
		obj.readme = http.get(obj.link)

		if not obj.readme then
			local res = http.download(obj.link,"ux0:data/AUTOPLUGIN2/tmp.txt")
			if res.headers and res.headers.status_code == 200 and files.exists("ux0:data/AUTOPLUGIN2/tmp.txt") then
				obj.readme = files.read("ux0:data/AUTOPLUGIN2/tmp.txt")
			end
			files.delete("ux0:data/AUTOPLUGIN2/tmp.txt")
		end
		if not obj.readme then obj.status = false else obj.status = true end
	end

	os.dialog(obj.readme or LANGUAGE["PLUGINS_NO_README_ONLINE"], obj.name.."\n")

	onNetGetFile = onNetGetFileOld

	local crc1,crc2,crc3,installed_prx = nil,nil,nil,false
	if obj.path_prx then crc1 = files.crc32(obj.path_prx) or nil end
	if obj.crc2 and obj.path2 and obj.path != "sysident.suprx" then
		crc2 = files.crc32(path_tai..obj.path2) or nil
	end--files.exists(path_tai..obj.path2)

--[[
	--PLugins que se pueden modificar sus valores,texto o imagen
	local customize,flag = nil,false
	if obj.path_prx then
		if obj.path == "TrImpose.suprx" then customize = customTransImpose_callback
			flag = true
		elseif obj.path == "custom_boot_splash.skprx" then customize = convertimgsplash_callback
			flag = true
		elseif obj.path == "AutoBoot.suprx" then customize = autoboot_callback
			flag = true
		elseif obj.path == "custom_warning.suprx" then customize = customwarning_callback
			flag = true
		elseif obj.path == "quickmenuplus.suprx" then customize = customQuickMenu_callback
			flag = true
		end
	end
]]
	--checks addons
	local addons = nil

	if obj.path == "reAuth.skprx" then
		addons = { 
			{ path = "libhttp.suprx", exists = false },
			{ path = "libssl.suprx", exists = false },
			{ path = "reAuth.suprx", exists = false },
		}
		for i = 1,#addons do
			if files.exists("ur0:data/reAuth/"..addons[i].path) then addons[i].exists = true end
		end

	elseif obj.path == "PSVshellPlus_Kernel.skprx" then
		addons = { 
			{ path = "psvshell_plugin.rco", exists = false },
		}
		for i = 1,#addons do
			if files.exists("ur0:data/PSVshell/"..addons[i].path) then addons[i].exists = true end
		end

	elseif obj.path == "sysident.suprx" then
		obj.path3 = "sysident.skprx"
		crc3 = files.crc32(path_tai.."sysident.skprx") or nil

	elseif obj.path == "QuickMenuReborn.suprx" then
		addons = { 
			{ path = "qmr_plugin.rco", exists = false },
		}
		for i = 1,#addons do
			if files.exists("ur0:QuickMenuReborn/"..addons[i].path) then addons[i].exists = true end
		end

		if obj.configpath then
			obj.path3 = obj.config
			crc3 = files.crc32(obj.configpath..obj.config) or nil
		end

	end

	--tai config
	if obj.section2 then obj.idx = tai.find(obj.section2,obj.path2) end
	if obj.idx != nil then
		--if files.exists(tai.gameid[ obj.section2 ].prx[obj.idx].path) then	end
	end

	local xscr1 = 10
	buttons.interval(10,6)
	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,obj.name,1.0,color.white,color.blue,__ACENTER)

		local y1 = 65
		--if obj.crc and obj.v then
			if obj.path_prx then
				if obj.path == "adrenaline_kernel.skprx" then
					screen.print(15, y1, LANGUAGE["MENU_INSTALLED_INFO"],1,color.white,color.blue,__ALEFT)
				else

					if obj.path == "QuickMenuReborn.suprx" and obj.configpath then
						if files.exists(obj.configpath..obj.config) then
							if obj.crc2 == crc3 then
								if screen.textwidth(obj.v) > 150 then
									screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION"].."\n"..obj.v,1,color.white,color.blue,__ALEFT)
									y1 += 25
								else
									screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION"]..obj.v,1,color.white,color.blue,__ALEFT)
								end
							else
								screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION"]..LANGUAGE["MENU_INFO_VERSION_UNK"],1,color.white,color.blue,__ALEFT)
							end
						else
							installed_prx = false
							screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION"]..LANGUAGE["MENU_INFO_VERSION_NONE"],1,color.white,color.blue,__ALEFT)
						end						

					elseif obj.crc == crc1 then
						if screen.textwidth(obj.v) > 150 then
							screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION"].."\n"..obj.v,1,color.white,color.blue,__ALEFT)
							y1 += 25
						else
							screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION"]..obj.v,1,color.white,color.blue,__ALEFT)
						end
					else
						screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION"]..LANGUAGE["MENU_INFO_VERSION_UNK"],1,color.white,color.blue,__ALEFT)
					end
				end
			else
				screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION"]..LANGUAGE["MENU_INFO_VERSION_NONE"],1,color.white,color.blue,__ALEFT)
			end
			y1 += 25
		--end

		if obj.v then
			if screen.textwidth(obj.v) > 150 then
				screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION_AP2"].."\n"..obj.v,1,color.white,color.blue,__ALEFT)
			else
				screen.print(15, y1, LANGUAGE["MENU_INFO_VERSION_AP2"]..obj.v,1,color.white,color.blue,__ALEFT)
			end
		end

		--Addons
		local y = 140
		if addons and #addons > 0 then
			screen.print(15, y, LANGUAGE["MENU_INFO_ADDONS"],1,color.white,color.blue,__ALEFT)
			y+=20
			for i = 1,#addons do
				--addons[i].len  = screen.print(15, y, addons[i].path,1,color.white,color.blue,__ALEFT)
				if addons[i].exists == true then
					screen.print(15, y, addons[i].path,1,color.green,0x0,__ALEFT)
				else
					screen.print(15, y, addons[i].path,1,color.yellow,0x0,__ALEFT)
				end
				y+=20
			end
		end

	if obj.path_prx then
		--Tai Config
		if obj.section then
			y+=20
			screen.print(15, y, "[ "..obj.section.." ]",1,color.white,0x0,__ALEFT)
		end
		if obj.path then
			y+=20
			if files.exists(obj.path_prx) then
				screen.print(15, y, obj.path,1,color.green,0x0,__ALEFT)
			else
				screen.print(15, y, obj.path,1,color.yellow,0x0,__ALEFT)
			end
		end
		if obj.section2 then
			y+=20
			screen.print(15, y, "[ "..obj.section2.." ]",1,color.white,0x0,__ALEFT)
		end
		if obj.path2 and obj.section2 then
			y+=20
			if obj.idx then
				screen.print(15, y, obj.path2,1,color.green,0x0,__ALEFT)
			else
				screen.print(15, y, obj.path2,1,color.yellow,0x0,__ALEFT)
			end
		end

		--CRC
		if obj.path != "adrenaline_kernel.skprx" then
			if obj.path2 then
				if crc3 then print_crc(y,obj.crc2,crc3,obj.path3)
					elseif crc2 then print_crc(y,obj.crc2,crc2,obj.path2)
						else print_crc(y,obj.crc2,crc2,obj.path2) end
			elseif obj.path3 then
				if crc3 then print_crc(y,obj.crc2,crc3,obj.path3) end
			end
		end
	end

		draw.fillrect(380,60,578,342,color.shine:a(35))
		draw.rect(380,60,578,342,color.green)
		if img then
			img:blit(380,60)
		end

		draw.fillrect(0,403,960,35,color.shine:a(55))
		if obj.desc then
			if screen.textwidth(obj.desc) > 925 then
				xscr1 = screen.print(xscr1, 415, obj.desc,1,color.green, 0x0,__SLEFT,935)
			else
				screen.print(480, 415, obj.desc,1,color.green, 0x0,__ACENTER)
			end
		end

--		if flag then
--			if buttonskey then buttonskey:blitsprite(10,472,__TRIANGLE) end
--			screen.print(45,475,LANGUAGE["MENU_INFO_PERSONALIZE"],1,color.white,color.blue, __ALEFT)
--		end

		if buttonskey then buttonskey:blitsprite(10,515,saccept) end
		if obj.path == "QuickMenuReborn.suprx" and obj.configpath then
			idx = tai.find(obj.section,obj.path)

			if not idx then screen.print(45,518,LANGUAGE["MENU_INSTALL_INFO"],1,color.white,color.blue, __ALEFT)
			else
		
				if files.exists(tai.gameid[ obj.section ].prx[idx].path) and files.exists(obj.configpath..obj.config) then
					screen.print(45,518,LANGUAGE["MENU_REINSTALL_INFO"],1,color.white,color.blue, __ALEFT)
				elseif files.exists(tai.gameid[ obj.section ].prx[idx].path) and not files.exists(obj.configpath..obj.config) then
					screen.print(45,518,LANGUAGE["MENU_INSTALL_INFO"],1,color.white,color.blue, __ALEFT)
				else
					screen.print(45,518,LANGUAGE["MENU_INSTALL_INFO"],1,color.white,color.blue, __ALEFT)
				end
			end
		else

			if obj.path_prx then
				screen.print(45,518,LANGUAGE["MENU_REINSTALL_INFO"],1,color.white,color.blue, __ALEFT)
			else
				screen.print(45,518,LANGUAGE["MENU_INSTALL_INFO"],1,color.white,color.blue, __ALEFT)
			end
		end

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,518,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--Controls

		if buttons.cancel then
			os.delay(100)
			return
		end

		--Exit
		if buttons.start then
			exit_bye_bye()
		end

		if buttons.left or buttons.right then xscr1 = 10 end

		if buttons.accept then
			
			--Install
			if obj.path:lower() == "vitacheat.skprx" then--360
				if not files.exists("ux0:data/AUTOPLUGIN2/font365.zip") then
					__file = "Vitacheat (Font)"
					local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/font365.zip", APP_REPO, APP_PROJECT, APP_FOLDER), "ux0:data/AUTOPLUGIN2/font365.zip")
					if res.headers and res.headers.status_code == 200 and files.exists("ux0:data/AUTOPLUGIN2/font365.zip") then
						plugins_installation(obj)
					else
						files.delete("ux0:data/AUTOPLUGIN2/font365.zip")
						os.message(LANGUAGE["LANG_ONLINE_FAILDB"].."\n\n"..LANGUAGE["UPDATE_WIFI_IS_ON"])
					end
				else
					plugins_installation(obj)
				end
			else plugins_installation(obj) end

			break
		end

		--if buttons.triangle and flag then customize() end

		vol_mp3()

	end

end

function print_crc(_y,_crc1,_crc2,_name)
	_y+=30
	screen.print(15, _y, LANGUAGE["MENU_INFO_CRC"],1,color.white,color.blue,__ALEFT)
	_y+=20
	if _crc1 == _crc2 then
	screen.print(15, _y, _name,1,color.green,0x0,__ALEFT)
	else
		screen.print(15, _y, _name,1,color.yellow,0x0,__ALEFT)
	end
end