--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function plugins_installation(sel)

	if plugins[sel].path:find("udcd_uvc",1,true) and hw.model() == "PlayStation TV" then os.message(LANGUAGE["INSTALLP_WARNING_UDCD"])
	elseif plugins[sel].path == "reF00D.skprx" and loc == __UX0 then os.message(LANGUAGE["INSTALLP_WARNING_REFOOD"])
	elseif plugins[sel].path == "custom_warning.suprx" and ( version == "3.67" or version == "3.68") then os.message(LANGUAGE["INSTALLP_CWARNING_360_365"])
	else

		local idx = nil
		if files.exists(tai[loc].path) then

			local install,udcd = true,false

			idx = tai.find(loc, "KERNEL", "udcd_uvc.skprx")
			if idx then
				tai.del(loc, "KERNEL", "udcd_uvc.skprx")
				udcd = true
			end

			--Checking plugin Batt (only 1 of them)
			if plugins[sel].path == "shellbat.suprx" then
				idx = tai.find(loc, "main", "shellsecbat.suprx")
				if idx then
					if os.message(LANGUAGE["INSTALLP_QUESTION_SHELLSECBAT"],1) == 1 then
						tai.del(loc, "main", "shellsecbat.suprx")
					else
						install = false
					end
				end
			elseif plugins[sel].path == "shellsecbat.suprx" then
				idx = tai.find(loc, "main", "shellbat.suprx")
				if idx then
					if os.message(LANGUAGE["INSTALLP_QUESTION_SHELLBAT"],1) == 1 then
						tai.del(loc, "main", "shellbat.suprx")
					else
						install = false
					end
				end
			elseif plugins[sel].path:find(string.lower("repatch"),1,true) then
				tai.del(loc, "KERNEL", "repatch.skprx")
				tai.del(loc, "KERNEL", "repatch_4.skprx")

			elseif plugins[sel].path == "vitastick.skprx" and not game.exists("VITASTICK") then
				__file = "vitastick.vpk"
				game.install("resources/plugins/vitastick.vpk",false)
				files.delete("ux0:data/AUTOPLUGIN2/vpks/")
			elseif plugins[sel].path == "ModalVol.suprx" and not game.exists("MODALVOLM") then
				__file = "VolumeControl.vpk"
				game.install("resources/plugins/VolumeControl.vpk",false)
				files.delete("ux0:data/AUTOPLUGIN2/vpks/")
			elseif plugins[sel].path == "monaural.skprx" and not game.exists("AKRK00003") then
				__file = "MonauralConfig.vpk"
				game.install("resources/plugins/MonauralConfig.vpk",false)
				files.delete("ux0:data/AUTOPLUGIN2/vpks/")
			elseif plugins[sel].path == "VitaGrafix.suprx" and not game.exists("VGCF00001") then
				files.delete("tmp")
				if back2 then back2:blit(0,0) end
					message_wait()
				os.delay(250)

				local onNetGetFileOld = onNetGetFile
				onNetGetFile = nil
				http.download("https://github.com/Kirezar/VitaGrafixConfigurator/releases/latest/","tmp")
				onNetGetFile = onNetGetFileOld
				if files.exists("tmp") then
					local objh = html.parsefile("tmp")
					if objh then

						local links = objh:findall(html.TAG_A)
						if links then
							--os.message("Links "..#links)
							for i=1,#links do
								if links[i].href then
									if links[i].href:find("VitaGrafixConfigurator.vpk",1,true) then
										--os.message(links[i].href)
										onNetGetFile = onNetGetFileOld
										__file = "VitaGrafixConfigurator.vpk"
										http.download("https://github.com"..links[i].href,"ux0:data/AUTOPLUGIN2/VitaGrafixConfigurator.vpk")
										http.getfile("https://raw.githubusercontent.com/Electry/VitaGrafixPatchlist/master/patchlist.txt", "ux0:data/VitaGrafix/patch/patchlist.txt")
										if files.exists("ux0:data/AUTOPLUGIN2/VitaGrafixConfigurator.vpk") then
											game.install("ux0:data/AUTOPLUGIN2/VitaGrafixConfigurator.vpk",false)
											files.delete("ux0:data/AUTOPLUGIN2/vpks/")
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

			end
			__file = ""

			if install then

				--Install plugin to tai folder
				files.copy(path_plugins..plugins[sel].path, path_tai)

				--Install Extra Plugin
				if plugins[sel].path2 then files.copy(path_plugins..plugins[sel].path2, path_tai) end

				--Install Especial Config for the plugin
				if plugins[sel].config then
					if plugins[sel].config == "custom_warning.txt" then
					
						if not files.exists(locations[loc].."tai/"..plugins[sel].config) then
							local text = osk.init(LANGUAGE["INSTALLP_OSK_TITLE"], LANGUAGE["INSTALLP_OSK_TEXT"])
							if not text or (string.len(text)<=0) then text = "" end--os.nick() end

							local fp = io.open(locations[loc].."tai/"..plugins[sel].config, "wb")
							if fp then
								fp:write(string.char(0xFF)..string.char(0xFE))
								fp:write(os.toucs2(text))
								fp:close()
							end
						end
					else
						if plugins[sel].configpath then
							files.copy(path_plugins..plugins[sel].config, plugins[sel].configpath)
						else
							files.copy(path_plugins..plugins[sel].config, locations[loc].."tai/")
						end
					end
				end

				--Insert plugin to Config
				local pathline_in_config = path_tai..plugins[sel].path

				if plugins[sel].path == "adrenaline_kernel.skprx" then pathline_in_config = "ux0:app/PSPEMUCFW/sce_module/adrenaline_kernel.skprx" end

				idx = nil

				if plugins[sel].section2 then
					idx = tai.find(loc, plugins[sel].section2, path_tai..plugins[sel].path2)
					if idx then tai.del(loc, plugins[sel].section2, path_tai..plugins[sel].path2) end
					tai.put(loc, plugins[sel].section2, path_tai..plugins[sel].path2)
				end

				idx = tai.find(loc, plugins[sel].section, pathline_in_config)
				if idx then tai.del(loc, plugins[sel].section,  pathline_in_config) end

				
				local plugin_name = plugins[sel].name

				if plugins[sel].path:find("udcd_uvc_",1,true) then
					--os.message("offs")
					if hw.model() == "Vita Fat" then
						tai.put(loc, plugins[sel].section,  path_tai.."udcd_uvc_oled_off.skprx")
						plugin_name = "udcd_uvc_oled"
					else
						tai.put(loc, plugins[sel].section,  path_tai.."udcd_uvc_lcd_off.skprx")
						plugin_name = "udcd_uvc_lcd"
					end
				else

					if plugins[sel].path:lower() == "custom_boot_splash.skprx" or (udcd or plugins[sel].path:lower() == "udcd_uvc.skprx") then
						--os.message("1")
						tai.put(loc, plugins[sel].section,  pathline_in_config)
						if udcd or plugins[sel].path:lower() == "udcd_uvc.skprx" then
							--os.message("udcd_uvc.skprx")
							tai.put(loc, "KERNEL",  path_tai.."udcd_uvc.skprx")
							tai.del(loc, "KERNEL", "udcd_uvc_oled_off.skprx")
							tai.del(loc, "KERNEL", "udcd_uvc_lcd_off.skprx")
						end

					else
						if plugins[sel].path:find("udcd_uvc_",1,true) then
							if hw.model() == "Vita Fat" then
								--os.message("udcd_uvc_oled   2")
								tai.put(loc, plugins[sel].section,  path_tai.."udcd_uvc_oled_off.skprx")
								plugin_name = "udcd_uvc_oled"
								tai.del(loc, "KERNEL", "udcd_uvc.skprx")
							else
								--os.message("udcd_uvc_lcd   2")
								tai.put(loc, plugins[sel].section,  path_tai.."udcd_uvc_lcd_off.skprx")
								plugin_name = "udcd_uvc_lcd"
								tai.del(loc, "KERNEL", "udcd_uvc.skprx")
							end
						else
							if (plugins[sel].path == "vitacheat.skprx") then --3.65
								tai.del(loc, "KERNEL", "vitacheat360.skprx")
							elseif (plugins[sel].path == "vitacheat360.skprx") then
								tai.del(loc, "KERNEL", "vitacheat.skprx")
							end
							--os.message("2")
							tai.put(loc, plugins[sel].section,  pathline_in_config)
						end

					end
				end

				--Write
				tai.sync(loc)

				--Extra
				if plugins[sel].path == "vsh.suprx" then files.delete("ur0:/data:/vsh/")
				elseif plugins[sel].path == "custom_boot_splash.skprx" and not files.exists("ur0:tai/boot_splash.bin") then--Custom Boot Splash
					local henkaku = image.load("imgs/boot_splash.png")
					if henkaku then img2splashbin(henkaku,false) end

				elseif plugins[sel].path == "vitacheat.skprx" then		--Vitacheat 3.65

					files.extract("resources/plugins/vitacheat.zip","ux0:")
					files.copy("resources/plugins/vitacheat365/vitacheat.suprx","ux0:vitacheat/")

				elseif plugins[sel].path == "vitacheat360.skprx" then	--Vitacheat 3.60

					files.extract("resources/plugins/vitacheat.zip","ux0:")
					files.copy("resources/plugins/vitacheat360/vitacheat.suprx","ux0:vitacheat/")

				elseif plugins[sel].path == "AutoBoot.suprx" and not files.exists("ux0:data/AutoBoot/") then--AutoBoot
					files.extract("resources/plugins/AutoBoot.zip","ux0:")
			    elseif plugins[sel].path == "ps4linkcontrols.suprx" and not files.exists("ux0:ps4linkcontrols.txt") then--ps4linkcontrols
					files.extract("resources/plugins/ps4linkcontrols.zip","ux0:")
				end

				if back2 then back2:blit(0,0) end
					message_wait(plugin_name.."\n\n"..LANGUAGE["STRING_INSTALLED"])
				os.delay(1500)
				change = true
			end

		else
			os.message(LANGUAGE["STRING_MISSING_CONFIG"])
		end
	end

end

function autoplugin()

	--Init load configs
	loc = 1
	tai.load()
	local partition = 0
	if tai[__UX0].exist then partition = __UX0
	elseif tai[__UR0].exist then partition,loc = __UR0,2
	end
	path_tai = locations[loc].."tai/"

	local limit = 9
	local scr = newScroll(plugins,limit)
	local xscr1,toinstall = 10,0
	scr.ini,scr.lim,scr.sel = 1,limit,1

	while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end
		if back2 then back2:blit(0,0) end

		screen.print(10,15,LANGUAGE["LIST_PLUGINS"].."  "..toinstall.."/"..#plugins,1,color.white)

		--Partitions
		local xRoot = 750
		local w = (960-xRoot)/#locations
		for i=1, #locations do
			if loc == i then
				draw.fillrect(xRoot,0,w,47, color.green:a(90))
			end
			screen.print(xRoot+(w/2), 12, locations[i], 1, color.white, color.blue, __ACENTER)
			xRoot += w
		end

		--List of Plugins
		local y = 64
		for i=scr.ini,scr.lim do

			if i == scr.sel then draw.offsetgradrect(3,y-9,944,31,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			idx = tai.find(partition,plugins[i].section,plugins[i].path)
			if idx != nil then
				if files.exists(tai[partition].gameid[ plugins[i].section ].prx[idx].path) then
					if dotg then dotg:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.green:a(205)) end
				else
					if doty then doty:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.yellow:a(205)) end
				end
			end

			if plugins[i].path2 == "kuio.skprx" or plugins[i].path2 == "ioplus.skprx" then
				screen.print(40,y, plugins[i].name, 1.2,color.white,color.blue:a(125),__ALEFT)
				screen.print(895,y, " ("..plugins[i].path2.." )", 1.0,color.yellow,color.blue,__ARIGHT)
			else
				screen.print(40,y, plugins[i].name, 1.2,color.white,color.blue:a(125),__ALEFT)
			end

			if plugins[i].inst then
				screen.print(5,y," >> ",1,color.white,color.green)
			end

			y+=36
		end

		---- Draw Scroll Bar
		local ybar,hbar = 60, (limit*36)
		draw.fillrect(950,ybar-2,8,hbar,color.shine)
		--if scr.maxim >= limit then
			local pos_height = math.max(hbar/scr.maxim, limit)
			--Bar Scroll
			draw.fillrect(950, ybar-2 + ((hbar-pos_height)/(scr.maxim-1))*(scr.sel-1), 8, pos_height, color.new(0,255,0))
		--end

		if screen.textwidth(plugins[scr.sel].desc) > 925 then
			xscr1 = screen.print(xscr1, 405, plugins[scr.sel].desc,1,color.green, 0x0,__SLEFT,935)
		else
			screen.print(480, 405, plugins[scr.sel].desc,1,color.green, 0x0,__ACENTER)
		end

		if tai[__UX0].exist and tai[__UR0].exist then
			if buttonskey2 then buttonskey2:blitsprite(900,448,2) end
			if buttonskey2 then buttonskey2:blitsprite(930,448,3) end
			screen.print(895,450,LANGUAGE["LR_SWAP"],1,color.white,color.black,__ARIGHT)
		end

		if buttonskey then buttonskey:blitsprite(10,448,__SQUARE) end
		screen.print(45,450,LANGUAGE["MARK_PLUGINS"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(5,472,0) end
		screen.print(45,475,LANGUAGE["CLEAN_PLUGINS"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,498,__TRIANGLE) end
		screen.print(45,500,LANGUAGE["PLUGINS_README_ONLINE"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(45,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.released.cancel then
			--Clean
			for i=1,scr.maxim do
				plugins[i].inst = false
				toinstall = 0
			end
			os.delay(100)
			return
		end

		--Exit
		if buttons.start then
			if change then
				os.message(LANGUAGE["STRING_PSVITA_RESTART"])
				os.delay(250)
				buttons.homepopup(1)
				power.restart()
			end
			os.exit()
		end

		if scr.maxim > 0 then
			if buttons.left or buttons.right then xscr1 = 10 end

			if buttons.up or buttons.analogly < -60 then
				if scr:up() then xscr1 = 10 end
			end
			if buttons.down or buttons.analogly > 60 then
				if scr:down() then xscr1 = 10 end
			end

			if buttons.released.l or buttons.released.r then
				if tai[__UX0].exist and tai[__UR0].exist then
					if loc == __UX0 then loc = __UR0 else loc = __UX0 end
				end
			end

			--Install selected plugins
			if buttons.accept then
				buttons.homepopup(0)
				if back2 then back2:blit(0,0) end
					message_wait()
				os.delay(1000)

				if toinstall <= 1 then
					plugins_installation(scr.sel)
				else
					for i=1, scr.maxim do
						if plugins[i].inst then
							plugins_installation(i)
						end
					end
					os.delay(50)
				end

				for i=1,scr.maxim do
					plugins[i].inst = false
					toinstall = 0
				end
				buttons.homepopup(1)
			end

			--Mark/Unmark
			if buttons.square then
				plugins[scr.sel].inst = not plugins[scr.sel].inst
				if plugins[scr.sel].inst then toinstall+=1 else toinstall-=1 end
			end

			--Clean selected
			if buttons.select then
				for i=1,scr.maxim do
					plugins[i].inst = false
					toinstall = 0
				end
			end

			--Readme online
			if buttons.triangle then
				local onNetGetFileOld = onNetGetFile
				onNetGetFile = nil
				--if back2 then back2:blit(0,0) end
				--message_wait()
				local readme = nil
				if plugins[scr.sel].link then readme = http.get(plugins[scr.sel].link) end
				os.dialog(readme or LANGUAGE["PLUGINS_NO_README_ONLINE"], plugins[scr.sel].name.."\n")
				onNetGetFile = onNetGetFileOld
			end
		end
	end

end
