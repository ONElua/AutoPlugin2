--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function psvita_plugins_online()

	files.delete("ux0:data/AUTOPLUGIN2/plugins/")
	files.delete("ux0:data/AUTOPLUGIN2/lang/")

	if back then back:blit(0,0) end
		draw.fillrect(0,0,960,55,color.black:a(100))
		draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_PSVITA_CHECK_ONLINE_PLUGINS"],1.2,color.white,0x0,__ACENTER)
		screen.flip()
	os.delay(500)

	buttons.homepopup(0)

	local tmp_plugins = {}
	local tmpdir = "ux0:data/AUTOPLUGIN2/plugins/"

	__file = "Database Plugins"
	--Online_Plugins
	local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/plugins/plugins.lua", APP_REPO, APP_PROJECT), tmpdir.."plugins.lua")
	if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."plugins.lua") then
		dofile(tmpdir.."plugins.lua")
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"].."\n\n"..LANGUAGE["UPDATE_WIFI_IS_ON"])
		return
	end

	local __flag = false
	if #Online_Plugins > 0 then

		draw.fillrect(0,0,960,55,color.black:a(100))
		draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_TITLE_PLUGINS_ONLINE"],1.2,color.white,0x0,__ACENTER)

		local onNetGetFileOld = onNetGetFile
		onNetGetFile = nil

		for i=1,#plugins do

			for j=1,#Online_Plugins do
				if string.upper(plugins[i].KEY) == string.upper(Online_Plugins[j].KEY) then

					if tonumber(plugins[i].version) < tonumber(Online_Plugins[j].version) then

						--os.message("Plugin\n"..Online_Plugins[j].name)

						local vitacheat_path = nil
						if Online_Plugins[j].path:lower() == "vitacheat360.skprx" then vitacheat_path = "vitacheat360"
						elseif Online_Plugins[j].path:lower() == "vitacheat.skprx" then vitacheat_path = "vitacheat365" end

						if vitacheat_path != nil then
							local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s/vitacheat.suprx", APP_REPO, APP_PROJECT, APP_FOLDER, vitacheat_path), tmpdir.."vitacheat.suprx")
							if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."vitacheat.suprx") then
								files.move(tmpdir.."vitacheat.suprx",path_plugins..vitacheat_path)
								if back2 then back2:blit(0,0) end
									message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..vitacheat_path)
								os.delay(100)
							end

							local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/vitacheat.zip", APP_REPO, APP_PROJECT, APP_FOLDER), tmpdir.."vitacheat.zip")
							if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."vitacheat.zip") then
								files.move(tmpdir.."vitacheat.zip",path_plugins)
								if back2 then back2:blit(0,0) end
									message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n".."vitacheat.zip")
								os.delay(100)
							end
						end

						--os.message("Try Plugin\n"..Online_Plugins[j].path)
						local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[j].path), tmpdir..Online_Plugins[j].path)
						if res.headers and res.headers.status_code == 200 and files.exists(tmpdir..Online_Plugins[j].path) then

							cont_global:set(tonumber(cont_global:get())-1)

							files.move(tmpdir..Online_Plugins[j].path, path_plugins)
							--os.message("Done Plugin\n"..Online_Plugins[j].path)

							if Online_Plugins[j].path2 then
								http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[j].path2), tmpdir..Online_Plugins[j].path2)
								files.move(tmpdir..Online_Plugins[j].path2, path_plugins)
							end

							if Online_Plugins[j].config then
								http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[j].config), tmpdir..Online_Plugins[j].config)
								files.move(tmpdir..Online_Plugins[j].config, path_plugins)
							end

							if Online_Plugins[j].dl then
								http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[j].dl), tmpdir..Online_Plugins[j].dl)
								files.move(tmpdir..Online_Plugins[j].dl, path_plugins)
							end

							if back2 then back2:blit(0,0) end
								message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_Plugins[j].name)
							os.delay(1000)

							table.insert(tmp_plugins,Online_Plugins[j])
							__flag = true

						end


					end
				end
			end

		end
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"])
		return

	end--Online_Plugins>0
	onNetGetFile = onNetGetFileOld

	local onNetGetFileOld = onNetGetFile
	onNetGetFile = nil

	--Plugins Nuevos
	for i=1,#Online_Plugins do
		local _find = false
		for j=1,#plugins do
			if string.upper(Online_Plugins[i].KEY) == string.upper(plugins[j].KEY) then
				_find = true
				break
			end
		end
		if not _find then

			draw.fillrect(0,0,960,55,color.black:a(100))
			draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
			screen.print(480,20,LANGUAGE["MENU_TITLE_PLUGINS_ONLINE"],1.2,color.white,0x0,__ACENTER)

			--os.message("Try New Plugin\n"..Online_Plugins[i].path)
			local vitacheat_path = nil
			if Online_Plugins[i].path:lower() == "vitacheat360.skprx" then vitacheat_path = "vitacheat360"
			elseif Online_Plugins[i].path:lower() == "vitacheat.skprx" then vitacheat_path = "vitacheat365" end

			if vitacheat_path != nil then
				local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s/vitacheat.suprx", APP_REPO, APP_PROJECT, APP_FOLDER, vitacheat_path), tmpdir.."vitacheat.suprx")
				if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."vitacheat.suprx") then
					files.move(tmpdir.."vitacheat.suprx",path_plugins..vitacheat_path)
					if back2 then back2:blit(0,0) end
						message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..vitacheat_path)
					os.delay(100)
				end

				local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/vitacheat.zip", APP_REPO, APP_PROJECT, APP_FOLDER), tmpdir.."vitacheat.zip")
				if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."vitacheat.zip") then
					files.move(tmpdir.."vitacheat.zip",path_plugins)
					if back2 then back2:blit(0,0) end
						message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n".."vitacheat.zip")
					os.delay(100)
				end
			end

			--os.message("Try Plugin\n"..Online_Plugins[i].path)
			local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[i].path), tmpdir..Online_Plugins[i].path)
			if res.headers and res.headers.status_code == 200 and files.exists(tmpdir..Online_Plugins[i].path) then

				cont_global:set(tonumber(cont_global:get())-1)

				files.move(tmpdir..Online_Plugins[i].path, path_plugins)

				if Online_Plugins[i].path2 then
					http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[i].path2), tmpdir..Online_Plugins[i].path2)
					files.move(tmpdir..Online_Plugins[i].path2, path_plugins)
				end

				if Online_Plugins[i].config then
					http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[i].config), tmpdir..Online_Plugins[i].config)
					files.move(tmpdir..Online_Plugins[i].config, path_plugins)
				end

				if Online_Plugins[i].dl then
					http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[i].dl), tmpdir..Online_Plugins[i].dl)
					files.move(tmpdir..Online_Plugins[i].dl, path_plugins)
				end

				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_Plugins[i].name)
				os.delay(1500)

				table.insert(tmp_plugins,Online_Plugins[i])
				tmp_plugins[#tmp_plugins].new = true
				__flag = true
			end
		end

	end
	onNetGetFile = onNetGetFileOld
--Clean
	files.delete("ux0:data/AUTOPLUGIN2/plugins/")
	files.delete("ux0:data/AUTOPLUGIN2/lang/")

	__file = ""
	if __flag then
		
		local onNetGetFileOld = onNetGetFile
		onNetGetFile = nil

		draw.fillrect(0,0,960,55,color.black:a(100))
		draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_TITLE_PLUGINS_ONLINE"],1.2,color.white,0x0,__ACENTER)

		local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/scripts/psvita/autoplugin.lua", APP_REPO, APP_PROJECT, APP_FOLDER), tmpdir.."autoplugin.lua")
		if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."autoplugin.lua") then
			files.move(tmpdir.."autoplugin.lua","scripts/psvita/")
			dofile("scripts/psvita/autoplugin.lua")--Official
		else
			files.delete(tmpdir.."autoplugin.lua")
		end

		--Update Langs
		update_lang(nil)
		files.delete("ux0:data/AUTOPLUGIN2/lang/")

		onNetGetFile = onNetGetFileOld

		local onNetGetFileOld = onNetGetFile
		onNetGetFile = nil

		local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/plugins/plugins.lua", APP_REPO, APP_PROJECT, APP_FOLDER), tmpdir.."plugins.lua")
		onNetGetFile = onNetGetFileOld

		if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."plugins.lua") then
			files.move(tmpdir.."plugins.lua","plugins/")
			dofile("plugins/plugins.lua")--Official
			if #plugins > 0 then table.sort(plugins, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end

			local tb_cop = {}
			update_translations(plugins, tb_cop)

			for k = #tb_cop,1,-1 do
				if tb_cop[k].path == "adrenaline_kernel.skprx" then	table.remove(tb_cop,k) end
				--No section
				if tb_cop[k].REMOVE then
					if tb_cop[k].path != "storagemgr.skprx" then files.copy(path_plugins..tb_cop[k].path, path_tai) end
				end
			end

			--Update plugin???
			for i=1,#tb_cop do
				for j=1,#tmp_plugins do
					--os.message("plugins: "..plugins[i].path.."\nupdates: "..tmp_plugins[j].path)
					if string.upper(tb_cop[i].path) == string.upper(tmp_plugins[j].path) then

						local idx = tai.find(tb_cop[i].section,tb_cop[i].path)
						if idx != nil then

							if os.dialog(tb_cop[i].path.."    "..LANGUAGE["UPDATE_QUESTION"], LANGUAGE["MENU_PSVITA_INSTALL_PLUGINS"], __DIALOG_MODE_OK_CANCEL) == true then
								--plugins_installation(tb_cop[i])

								local onExtractFilesOld = onExtractFiles
								onExtractFiles = nil

								--Copy Especial Config for the plugin
								if tb_cop[i].config then
									if not tb_cop[i].configpath then
										--os.message(path_plugins..tb_cop[i].config)
										if not files.exists(path_tai..tb_cop[i].config) then files.copy(path_plugins..tb_cop[i].config, path_tai) end
									else
										if files.ext(tb_cop[i].config):upper() == "ZIP" then
											files.extract(path_plugins..tb_cop[i].config,tb_cop[i].configpath)
										else
											--os.message(tb_cop[i].configpath..tb_cop[i].config)
											if not files.exists(tb_cop[i].configpath..tb_cop[i].config) then
												files.copy(path_plugins..tb_cop[i].config, tb_cop[i].configpath)
											end
										end
									end
								end
								onExtractFiles = onExtractFilesOld

								--Copy plugin to tai folder
								files.copy(path_plugins..tb_cop[i].path, path_tai)

								--Copy Extra Plugin (Path2)
								if tb_cop[i].path2 then files.copy(path_plugins..tb_cop[i].path2, path_tai) end

								if tb_cop[i].path == "sysident.suprx" then files.copy(path_plugins.."sysident.skprx", path_tai)
								elseif tb_cop[i].path == "vitacheat.skprx" then files.copy("resources/plugins/vitacheat365/vitacheat.suprx","ux0:vitacheat/")
								elseif tb_cop[i].path == "vitacheat360.skprx" then files.copy("resources/plugins/vitacheat360/vitacheat.suprx","ux0:vitacheat/")
								elseif tb_cop[i].path == "reVita.skprx" then files.copy(path_plugins.."reVitaMotion.suprx", path_tai)
								end

								change,ReloadConfig = true,true
							end
						end
						
						
					end
				end
			end

		else
			os.message(LANGUAGE["LANG_ONLINE_FAILDB"].."\n\n"..LANGUAGE["UPDATE_WIFI_IS_ON"])
			return
		end
	end

	buttons.homepopup(1)

	local maxim,y1 = 10,85
	local scroll = newScroll(tmp_plugins,maxim)
	table.sort(tmp_plugins ,function (a,b) return string.lower(a.name)<string.lower(b.name) end)

	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_TITLE_PLUGINS_ONLINE"],1.2,color.white,0x0,__ACENTER)

		if scroll.maxim > 0 then

			local y = y1
			for i=scroll.ini,scroll.lim do

				if i == scroll.sel then draw.offsetgradrect(17,y-12,938,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

				if tmp_plugins[i].v then
					screen.print(30,y, tmp_plugins[i].name.." "..tmp_plugins[i].v, 1.0, color.white,0x0)
				else
					screen.print(30,y, tmp_plugins[i].name, 1.0, color.white,0x0)
				end
				if tmp_plugins[i].new then
					screen.print(945,y,LANGUAGE["LANG_FILE_NEW"],1.0,color.green,0x0,__ARIGHT)
				else
					screen.print(945,y,LANGUAGE["LANG_FILE_UPDATE"],1.0,color.green,0x0,__ARIGHT)
				end

				y+= 40

			end--for

			--Bar Scroll
			local ybar, h = y1-8, (maxim*40)-3
			if scroll.maxim >= maxim then -- Draw Scroll Bar
				draw.fillrect(3, ybar-3, 8, h, color.shine)
				local pos_height = math.max(h/scroll.maxim, maxim)
				draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))
			end

		else
			screen.print(480,230, LANGUAGE["PLUGINS_NO_ONLINE"], 1, color.white, color.red, __ACENTER)
		end

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(45,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--Exit
		if buttons.start then
			exit_bye_bye()
		end

		vol_mp3()

		--Ctrls
		if scroll.maxim > 0 then

			if buttons.up or buttons.analogly < -60 then scroll:up() end
			if buttons.down or buttons.analogly > 60 then scroll:down()	end

		end

		if buttons.cancel then break end
	
	end--while

end
