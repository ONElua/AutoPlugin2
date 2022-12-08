--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function psp_plugins_online()

	files.delete("ux0:data/AUTOPLUGIN2/plugins/")
	files.delete("ux0:data/AUTOPLUGIN2/lang/")

	buttons.homepopup(0)

	local tmp_plugins = {}
	local tmpdir = "ux0:data/AUTOPLUGIN2/plugins/"

	__file = "Database Plugins"
	--Online_Plugins
	local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/plugins/plugins_psp.lua", APP_REPO, APP_PROJECT), tmpdir.."plugins_psp.lua")
	if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."plugins_psp.lua") then
		dofile(tmpdir.."plugins_psp.lua")
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"].."\n\n"..LANGUAGE["UPDATE_WIFI_IS_ON"])
		return
	end

	local __flag = false

	--Plugins for PSP (Adrenaline)
	if #Online_pluginsP > 0 then

		local onNetGetFileOld = onNetGetFile
		onNetGetFile = nil

		for i=1,#pluginsP do

			for j=1,#Online_pluginsP do
				if string.upper(pluginsP[i].KEY) == string.upper(Online_pluginsP[j].KEY) then

					if tonumber(pluginsP[i].version) < tonumber(Online_pluginsP[j].version) then

						--os.message("Plugin\n"..Online_pluginsP[j].name)

						local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_pluginsP[j].name), tmpdir..Online_pluginsP[j].name)
						if res.headers and res.headers.status_code == 200 and files.exists(tmpdir..Online_pluginsP[j].name) then
							files.move(tmpdir..Online_pluginsP[j].name,"resources/plugins_psp/")

							if Online_pluginsP[j].config then
								http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_pluginsP[j].config), tmpdir..Online_pluginsP[j].config)
								files.move(tmpdir..Online_pluginsP[j].config,"resources/plugins_psp/")
							end

							if back2 then back2:blit(0,0) end
								message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_pluginsP[j].nameR)
							os.delay(1500)

							table.insert(tmp_plugins,pluginsP[i])
							__flag = true
						end

					end
				end
			end

		end--for

	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"])
		return

	end--Online_PluginsP>0

	--Plugins for PSP Remastered Controls (Adrenaline)
	if #Online_psp_plugins > 0 then
		for i=1,#psp_plugins do

			for j=1,#Online_psp_plugins do
				if string.upper(psp_plugins[i].KEY) == string.upper(Online_psp_plugins[j].KEY) then

					if tonumber(psp_plugins[i].version) < tonumber(Online_psp_plugins[j].version) then

						--os.message("Plugin: \n"..Online_psp_plugins[j].path)

						http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/controls_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_psp_plugins[j].path), tmpdir..Online_psp_plugins[j].path)
						if res.headers and res.headers.status_code == 200 and files.exists(tmpdir..Online_psp_plugins[j].path) then
							files.move(tmpdir..Online_psp_plugins[j].path,"resources/plugins_psp/controls_psp/")

							if back2 then back2:blit(0,0) end
								message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_psp_plugins[j].name)
							os.delay(1500)

							table.insert(tmp_plugins,psp_plugins[i])
							__flag = true
						end

					end
				end
			end

		end--for

	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"])
		return

	end--Online_pluginsP>0

	--Plugins Nuevos
	for i=1,#Online_pluginsP do
		local _find = false
		for j=1,#pluginsP do
			if string.upper(Online_pluginsP[i].KEY) == string.upper(pluginsP[j].KEY) then
				_find = true
				break
			end
		end
		if not _find then

			--os.message("1 Try New Plugin\n"..Online_pluginsP[i].nameR)

			local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_pluginsP[i].name), tmpdir..Online_pluginsP[i].name)
			if res.headers and res.headers.status_code == 200 and files.exists(tmpdir..Online_pluginsP[i].name) then
				files.move(tmpdir..Online_pluginsP[i].name,"resources/plugins_psp/")

				if Online_pluginsP[i].config then
					http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_pluginsP[i].config), tmpdir..Online_pluginsP[i].config)
					files.move(tmpdir..Online_pluginsP[i].config,"resources/plugins_psp/")
				end

				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_pluginsP[i].nameR)
				os.delay(1500)

				table.insert(tmp_plugins,Online_PluginsP[i])
				tmp_plugins[#tmp_plugins].new = true
				__flag = true
			end
		end
	end

	--Plugins for Remastered Controls
	for i=1,#Online_psp_plugins do
		local _find = false
		for j=1,#psp_plugins do
			
			if string.upper(Online_psp_plugins[i].KEY) == string.upper(psp_plugins[j].KEY) then
				_find = true
				break
			end
		end
		if not _find then

			--os.message("2 Try New Plugin\n"..Online_psp_plugins[i].name)

			local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/controls_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_psp_plugins[i].path), tmpdir..Online_psp_plugins[i].path)
			if res.headers and res.headers.status_code == 200 and files.exists(tmpdir..Online_psp_plugins[i].path) then
				files.move(tmpdir..Online_psp_plugins[i].path,"resources/plugins_psp/controls_psp/")
				
				if Online_psp_plugins[i].config then
					http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/controls_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_psp_plugins[i].config), tmp..Online_psp_plugins[i].config)
					files.move(tmpdir..Online_psp_plugins[i].config,"resources/plugins_psp/controls_psp/")
				end

				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_psp_plugins[i].path)
				os.delay(1500)

				table.insert(tmp_plugins,Online_psp_plugins[i])
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
	
		--Update Langs
		update_lang(nil)
		files.delete("ux0:data/AUTOPLUGIN2/lang/")

		onNetGetFile = onNetGetFileOld

		local onNetGetFileOld = onNetGetFile
		onNetGetFile = nil
		local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/plugins/plugins_psp.lua", APP_REPO, APP_PROJECT, APP_FOLDER), tmpdir.."plugins_psp.lua")
		onNetGetFile = onNetGetFileOld

		if res.headers and res.headers.status_code == 200 and files.exists(tmpdir.."plugins_psp.lua") then
			files.move(tmpdir.."plugins_psp.lua","plugins/")
			dofile("plugins/plugins_psp.lua")--Official
			if #pluginsP > 0 then table.sort(pluginsP, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end
			if #psp_plugins > 0 then table.sort(psp_plugins, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end

		--aqui actualizar plugins en pspemu/seplugins

			local plugins_status={}
			read_configs(pluginsP,plugins_status)

			local tb_cop = {}
			update_translations(pluginsP, tb_cop)

			--Update plugin???
			for i=1,#tb_cop do
				for j=1,#tmp_plugins do

					if string.upper(tb_cop[i].name) == string.upper(tmp_plugins[j].name) then
						--os.message("plugins: "..tb_cop[i].path.."\nupdates: "..tmp_plugins[j].path)
						for k=1, #PMounts do
							if plugins_status[ PMounts[k]..tb_cop[i].name:lower() ] then
								os.message(PMounts[k].."pspemu/"..tb_cop[i].path)
								--install plugin
								files.copy("resources/plugins_psp/"..tb_cop[i].name, PMounts[k].."pspemu/"..tb_cop[i].path)

								--install config
								if tb_cop[i].config then
									files.copy("resources/plugins_psp/"..tb_cop[i].config, PMounts[k].."pspemu/"..tb_cop[i].path)
								end
							end
						end
					end
				end
			end

			local plugins_status={}
			read_configs_pspctrls(psp_plugins,plugins_status)

			local tb_cop = {}
			update_translations(psp_plugins, tb_cop)

			--Update psp_plugins???
			for i=1,#tb_cop do
				for j=1,#tmp_plugins do

					if string.upper(tb_cop[i].path) == string.upper(tmp_plugins[j].path) then
						--os.message("plugins: "..tb_cop[i].path.."\nupdates: "..tmp_plugins[j].path)
						for k=1, #PMounts do
							if plugins_status[ PMounts[k]..tb_cop[i].path:lower() ] then
								os.message(PMounts[k].."pspemu/seplugins/"..tb_cop[i].path)
								--install plugin
								files.copy("resources/plugins_psp/controls_psp/"..tb_cop[i].path, PMounts[k].."pspemu/seplugins/")
							end
						end
					end
				end
			end
			
			
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

				screen.print(30,y, tmp_plugins[i].nameR or tmp_plugins[i].name, 1.0, color.white,0x0)
				
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
