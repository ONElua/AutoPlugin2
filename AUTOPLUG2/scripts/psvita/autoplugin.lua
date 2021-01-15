--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

screenshots = "ux0:data/AUTOPLUGIN2/screenshots/"
files.mkdir(screenshots)

function plugins_installation(tb,sel)

	if tb[sel].path:find(string.lower("udcd_uvc"),1,true) and hw.model() == "PlayStation TV" then os.message(LANGUAGE["INSTALLP_WARNING_UDCD"])
	elseif tb[sel].path == "custom_warning.suprx" and ( version == "3.67" or version == "3.68" or version == "3.73") then os.message(LANGUAGE["INSTALLP_CWARNING_360_365"])
	elseif tb[sel].path == "reVita.skprx" and ( version == "3.67" or version == "3.68" or version == "3.73") then os.message(LANGUAGE["INSTALLP_CWARNING_360_365"])
	elseif tb[sel].path == "pspemu-colour-crunch.skprx" and hw.model() != "Vita Slim" then os.message(LANGUAGE["INSTALLP_LCDCOLOURSPACECHANGE"])
	else

		--Aqui checaremos posibles conflictos de plugins
		if tb[sel].path == "sharpscale.skprx" and not tai.check("!AKRK00005") then
			tai.putBeforeSection("ALL","!AKRK00005","")

		--Ds4Touch
		elseif tb[sel].path == "ds4touch.skprx" then
			tai.del("ALL",  "ds4touch.suprx")

		-- Sysident
		elseif tb[sel].path == "sysident.suprx" then
			tai.put("KERNEL",  path_tai.."sysident.skprx")
			files.copy(path_plugins.."sysident.skprx", "ur0:tai/")
			change = true

		-- QuickMenuPlus
		elseif tb[sel].path == "quickmenuplus.suprx" then
			tai.del("main", "quick_power.suprx")
			tai.del("main", "quick_volume.suprx")
			tai.del("KERNEL", "rapidmenu.skprx")

		--Checking plugin Batt (only 1 of them)
		elseif tb[sel].path == "shellbat.suprx" then
			tai.del("main", "shellsecbat.suprx")
		elseif tb[sel].path == "shellsecbat.suprx" then
			tai.del("main", "shellbat.suprx")

		-- Repatch
		elseif tb[sel].path:find(string.lower("repatch"),1,true) then
			tai.del("KERNEL", "repatch.skprx")
			tai.del("KERNEL", "repatch_4.skprx")

		--Refood or syscall
		elseif tb[sel].path == "reF00D.skprx" then
			tai.del("KERNEL", "0syscall6.skprx")
		elseif tb[sel].path == "0syscall6.skprx" then
			tai.del("KERNEL", "reF00D.skprx")

		--Vitacheat
		elseif tb[sel].path:find(string.lower("vitacheat"),1,true) then
			tai.del("KERNEL", "vitacheat360.skprx")
			tai.del("KERNEL", "vitacheat.skprx")

		--udcd
		elseif tb[sel].path:find(string.lower("udcd_uvc"),1,true) then
			--os.message("delete udcds")
			tai.del("KERNEL", "udcd_uvc.skprx")
			tai.del("KERNEL", "udcd_uvc_oled_off.skprx")
			tai.del("KERNEL", "udcd_uvc_lcd_off.skprx")
		end

		--Aqui vamos a hacer que los vpks se descarguen y se instalen
		
		if tb[sel].vpk then
			__file = files.nopath(tb[sel].vpk)
			os.message(__file.." "..LANGUAGE["INSTALLP_QUESTION_VPK"],0)
			local path2vpk = "ux0:data/AUTOPLUGIN2/vpks/"..__file
			if http.download(tb[sel].vpk, path2vpk).success and files.exists(path2vpk) then
				game.install("ux0:data/AUTOPLUGIN2/vpks/"..__file,false)
			else
				os.message(LANGUAGE["INSTALLP_NO_VPK"])
			end
		end

		if tb[sel].path == "vitastick.skprx" then
			__file = "vitastick.vpk"
			game.install("resources/plugins/vitastick.vpk",false)
		elseif tb[sel].path == "ModalVol.suprx" then
			__file = "VolumeControl.vpk"
			game.install("resources/plugins/VolumeControl.vpk",false)
		elseif tb[sel].path == "monaural.skprx" then
			__file = "MonauralConfig.vpk"
			game.install("resources/plugins/MonauralConfig.vpk",false)
		elseif tb[sel].path == "pspemu-colour-crunch.skprx" then
			__file = "lcd-colour-crunch.vpk"
			game.install("resources/plugins/lcd-colour-crunch.vpk",false)
		elseif tb[sel].path == "vitabright.skprx" then
			files.delete("tmp")
			if back2 then back2:blit(0,0) end
				message_wait()
			os.delay(250)
			
			local onNetGetFileOld = onNetGetFile
			onNetGetFile = nil
			http.download("https://github.com/devnoname120/vitabright-lut-editor/releases/latest/","tmp")
			onNetGetFile = onNetGetFileOld
			if files.exists("tmp") then
				local objh = html.parsefile("tmp")
				if objh then

					local links = objh:findall(html.TAG_A)
					if links then
						--os.message("Links "..#links)
						for i=1,#links do
							if links[i].href then
								if links[i].href:find(".vpk",1,true) then
									--os.message(links[i].href)
									onNetGetFile = onNetGetFileOld
									__file = "VitabrightLutEditor.vpk"
									http.download("https://github.com"..links[i].href,"ux0:data/AUTOPLUGIN2/vitabrightluteditor.vpk")
									if files.exists("ux0:data/AUTOPLUGIN2/vitabrightluteditor.vpk") then
										game.install("ux0:data/AUTOPLUGIN2/vitabrightluteditor.vpk",false)
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
			
			
		elseif tb[sel].path == "VitaGrafix.suprx" then
			files.delete("tmp")
			if back2 then back2:blit(0,0) end
				message_wait()
			os.delay(250)

			files.copy(path_plugins.."vitagrafix/patch/", "ux0:data/VitaGrafix/")
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
									http.getfile("https://raw.githubusercontent.com/Electry/VitaGrafixPatchlist/master/patchlist.txt", "ux0:data/VitaGrafix/patchlist.txt")
									if files.exists("ux0:data/AUTOPLUGIN2/VitaGrafixConfigurator.vpk") then
										game.install("ux0:data/AUTOPLUGIN2/VitaGrafixConfigurator.vpk",false)
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

		--Clean
		files.delete("tmp")
		files.delete("ux0:data/AUTOPLUGIN2/vpks/")
		__file = ""


		--Delete plugins Specials
		if tb[sel].tai_del1 and tb[sel].section_del1 then
			--os.message("section1: "..tb[sel].section_del1.."\n".."plugin1: "..tb[sel].tai_del1)
			tai.del(tb[sel].section_del1, tb[sel].tai_del1)

			if tb[sel].section_del1:upper() == "MAIN" or tb[sel].section_del1:upper() == "KERNEL" then change = true end
		end
		if tb[sel].tai_del2 and tb[sel].section_del2 then
			--os.message("section2: "..tb[sel].section_del2.."\n".."plugin2: "..tb[sel].tai_del2)
			tai.del(tb[sel].section_del2, tb[sel].tai_del2)

			if tb[sel].section_del2:upper() == "MAIN" or tb[sel].section_del2:upper() == "KERNEL" then change = true end
		end

		--Copy Especial Config for the plugin
		if tb[sel].config then
			if tb[sel].config == "custom_warning.txt" then
				if not files.exists("ur0:tai/"..tb[sel].config) then
					local text = osk.init(LANGUAGE["INSTALLP_OSK_TITLE"], LANGUAGE["INSTALLP_OSK_TEXT"])
					if not text or (string.len(text)<=0) then text = "" end--os.nick() end

					local fp = io.open("ur0:tai/"..tb[sel].config, "wb")
					if fp then
						fp:write(string.char(0xFF)..string.char(0xFE))
						fp:write(os.toucs2(text))
						fp:close()
						files.delete("ux0:tai/custom_warning.txt")
					end
				end
			else
				files.copy(path_plugins..tb[sel].config, tb[sel].configpath or "ur0:tai/")
			end
		end

		--Insert plugin to Config
		local pathline_in_config = path_tai..tb[sel].path

		if tb[sel].path == "adrenaline_kernel.skprx" then pathline_in_config = "ux0:app/PSPEMUCFW/sce_module/adrenaline_kernel.skprx" end

		--Aqui colocamos el plugin seleccionado al config tai
		local plugin_name = tb[sel].name
		local plugin_path = tb[sel].path

		if tb[sel].path:find("udcd_uvc_",1,true) then
			if hw.model() == "Vita Fat" then
				--os.message("Fat")
				tai.put(tb[sel].section,  path_tai.."udcd_uvc_oled_off.skprx")
				plugin_name = "udcd_uvc_oled"
				plugin_path = "udcd_uvc_oled_off.skprx"
			else
				--os.message("Slim")
				tai.put(tb[sel].section,  path_tai.."udcd_uvc_lcd_off.skprx")
				plugin_name = "udcd_uvc_lcd"
				plugin_path = "udcd_uvc_lcd_off.skprx"
			end
		else
			tai.put(tb[sel].section,  pathline_in_config)
		end

		--Copy plugin to tai folder
		files.copy(path_plugins..plugin_path, path_tai)

		--Copy Extra Plugin (section2 & Path2)
		if tb[sel].path2 then files.copy(path_plugins..tb[sel].path2, path_tai) end

		if tb[sel].section2 then
			tai.put(tb[sel].section2, path_tai..tb[sel].path2)
		end

		--Extra
		if tb[sel].path == "vsh.suprx" then files.delete("ur0:/data:/vsh/")
		elseif tb[sel].path == "custom_boot_splash.skprx" and not files.exists("ur0:tai/boot_splash.bin") then--Custom Boot Splash
			local henkaku = image.load("imgs/boot_splash.png")
			if henkaku then img2splashbin(henkaku,false) end

		elseif tb[sel].path == "vitacheat.skprx" then		--Vitacheat 3.65

			files.extract("resources/plugins/vitacheat.zip","ux0:")
			files.copy("resources/plugins/vitacheat365/vitacheat.suprx","ux0:vitacheat/")

		elseif tb[sel].path == "vitacheat360.skprx" then	--Vitacheat 3.60

			files.extract("resources/plugins/vitacheat.zip","ux0:")
			files.copy("resources/plugins/vitacheat360/vitacheat.suprx","ux0:vitacheat/")

		elseif tb[sel].path == "AutoBoot.suprx" and not files.exists("ux0:data/AutoBoot/boot.cfg") then--AutoBoot
			files.extract("resources/plugins/AutoBoot.zip","ux0:")
		elseif tb[sel].path == "ps4linkcontrols.suprx" and not files.exists("ux0:ps4linkcontrols.txt") then--ps4linkcontrols
			files.extract("resources/plugins/ps4linkcontrols.zip","ux0:")
				-- reVita.skprx
		elseif tb[sel].path == "reVita.skprx" then
			if os.message(LANGUAGE["INSTALLP_DESC_REVITA_GYRO"].."\n",1) == 1 then
				files.copy(path_plugins.."reVitaMotion.suprx", "ur0:tai/")
				tai.put("main",  path_tai.."reVitaMotion.suprx")
				change = true
			end
		end

		if tb[sel].section2 and tb[sel].section2:upper() == "KERNEL" then
			change = true
		end

		if tb[sel].section:upper() == "MAIN" or tb[sel].section:upper() == "KERNEL" then
			change = true
		else
			ReloadConfig = true
		end

		if back2 then back2:blit(0,0) end
			message_wait(plugin_name.."\n\n"..LANGUAGE["STRING_INSTALLED"])
		os.delay(1500)

	end

end

function autoplugin()

	local tb_cop = {}
	update_translations(plugins, tb_cop)

	for k = #tb_cop,1,-1 do
		if tb_cop[k].REMOVE then
			table.remove(tb_cop,k)
		end
	end

	local limit = 9
	local scr = newScroll(tb_cop,limit)
	local xscr1,toinstall = 10,0
	scr.ini,scr.lim,scr.sel = 1,limit,1

	--local icon0 = nil
	while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end
		if back2 then back2:blit(0,0) end

		screen.print(10,15,LANGUAGE["LIST_PLUGINS"].."  "..toinstall.."/"..#tb_cop,1,color.white)

		--Partition
		draw.fillrect(860,0,100,40, color.green:a(90))
		screen.print(930, 12, "ur0:", 1, color.white, color.blue, __ARIGHT)

		--List of Plugins
		local y = 64
		for i=scr.ini,scr.lim do

			if i == scr.sel then draw.offsetgradrect(3,y-9,944,31,color.shine:a(75),color.shine:a(135),0x0,0x0,21)
			
--[[
				if not icon0 then
					icon0 = image.load(screenshots..tb_cop[scr.sel].id)
					if icon0 then
						icon0:resize(260,150)
						icon0:setfilter(__IMG_FILTER_LINEAR, __IMG_FILTER_LINEAR)
					end
				end
]]
			end

			idx = tai.find(tb_cop[i].section,tb_cop[i].path)
			if idx != nil then
				if files.exists(tai.gameid[ tb_cop[i].section ].prx[idx].path) then
					if dotg then dotg:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.green:a(205)) end
				else
					if doty then doty:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.yellow:a(205)) end
				end
			end

			if tb_cop[i].path2 == "kuio.skprx" or tb_cop[i].path2 == "ioplus.skprx" then
				screen.print(40,y, tb_cop[i].name, 1.2,color.white,color.blue:a(125),__ALEFT)
				screen.print(895,y, " ("..tb_cop[i].path2.." )", 1.0,color.yellow,color.blue,__ARIGHT)
			else
				screen.print(40,y, tb_cop[i].name, 1.2,color.white,color.blue:a(125),__ALEFT)
			end

			if tb_cop[i].inst then
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

--[[
		--Blit icon0
		if icon0 then
			icon0:blit(650, 45)
		end
]]

		if tb_cop[scr.sel].desc then
			if screen.textwidth(tb_cop[scr.sel].desc) > 925 then
				xscr1 = screen.print(xscr1, 405, tb_cop[scr.sel].desc,1,color.green, 0x0,__SLEFT,935)
			else
				screen.print(480, 405, tb_cop[scr.sel].desc,1,color.green, 0x0,__ACENTER)
			end
		end

		screen.print(950, 433, tb_cop[scr.sel].section,1,color.yellow, 0x0,__ARIGHT)
		screen.print(950, 455, tb_cop[scr.sel].path,1,color.yellow, 0x0,__ARIGHT)
		if tb_cop[scr.sel].section2 then
			screen.print(950, 480, tb_cop[scr.sel].section2,1,color.yellow, 0x0,__ARIGHT)
			screen.print(950, 500, tb_cop[scr.sel].path2,1,color.yellow, 0x0,__ARIGHT)
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

		--if buttons.select then error("FTP") end
		if buttons.cancel then
			--Clean
			for i=1,scr.maxim do
				tb_cop[i].inst = false
				toinstall = 0
			end
			os.delay(100)
			return
		end

		--Exit
		if buttons.start then
			exit_bye_bye()
		end

		vol_mp3()

		if scr.maxim > 0 then
			if buttons.left or buttons.right then xscr1 = 10 end

			if buttons.up or buttons.analogly < -60 then
				if scr:up() then xscr1 = 10
					icon0 = nil
				end
			end
			if buttons.down or buttons.analogly > 60 then
				if scr:down() then xscr1 = 10
					icon0 = nil
				end
			end

			--Install selected plugins
			if buttons.accept then
				buttons.homepopup(0)
				if back2 then back2:blit(0,0) end
					message_wait()
				os.delay(1000)

				if toinstall <= 1 then
					plugins_installation(tb_cop,scr.sel)
				else
					for i=1, scr.maxim do
						if tb_cop[i].inst then
							plugins_installation(tb_cop,i)
						end
					end
					os.delay(50)
				end

				for i=1,scr.maxim do
					tb_cop[i].inst = false
					toinstall = 0
				end
				buttons.homepopup(1)
			end

			--Mark/Unmark
			if buttons.square then
				tb_cop[scr.sel].inst = not tb_cop[scr.sel].inst
				if tb_cop[scr.sel].inst then toinstall+=1 else toinstall-=1 end
			end

			--Clean selected
			if buttons.select then
				for i=1,scr.maxim do
					tb_cop[i].inst = false
					toinstall = 0
				end
			end

			--Readme online
			if buttons.triangle then

				local vbuff = screen.buffertoimage()

				local onNetGetFileOld = onNetGetFile
				onNetGetFile = nil

				local SCREENSHOT,img = nil,nil
				if tb_cop[scr.sel].id then
					SCREENSHOT = string.format("https://raw.githubusercontent.com/%s/%s/master/screenshots/%s", APP_REPO, APP_PROJECT, tb_cop[scr.sel].id)
					img = image.load(screenshots..tb_cop[scr.sel].id)
					if not img then
						if http.getfile(SCREENSHOT, screenshots..tb_cop[scr.sel].id) then
							img = image.load(screenshots..tb_cop[scr.sel].id)
						end
					end
				end

				if tb_cop[scr.sel].link and not tb_cop[scr.sel].status then
					tb_cop[scr.sel].readme = http.get(tb_cop[scr.sel].link)
					if not tb_cop[scr.sel].readme then tb_cop[scr.sel].status = false else tb_cop[scr.sel].status = true end
					--os.message("get readme")
				end

				os.dialog(tb_cop[scr.sel].readme or LANGUAGE["PLUGINS_NO_README_ONLINE"], tb_cop[scr.sel].name.."\n")

				if img then
					if vbuff then vbuff:blit(0,0) elseif back2 then back2:blit(0,0) end
					img:setfilter(__IMG_FILTER_LINEAR, __IMG_FILTER_LINEAR)
					img:scale(85)
					img:center()
					img:blit(480,272)
					screen.flip()
					buttons.waitforkey()
					os.delay(150)
				end

				img,vbuff = nil,nil
				onNetGetFile = onNetGetFileOld
				os.delay(75)

			end

		end
	end

end
