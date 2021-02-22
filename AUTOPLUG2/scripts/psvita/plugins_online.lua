--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function update_database2(database,tb)

	local file = io.open(database, "w+")

    file:write("plugins = {\n")

	for s,t in pairs(tb) do
		file:write("{ ")
			if type(t) == "table" then
				for k,v in pairs(t) do
					if k != "install" and k != "new" and k != "inst" then
						file:write(string.format(' %s = "%s",', tostring(k), tostring(v)))
					end
				end
		file:write("},\n")
			end
	end

	file:write("}\n")
	file:close()


	local cont = {}
	for line in io.lines(database) do
		if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13
		table.insert(cont,line)
	end


	dofile("plugins/plugins.lua")--Official
	for i=1,#plugins do
		for j=1, #cont do
			if string.find(cont[j], plugins[i].KEY, 1, true) then
				cont[j] = cont[j]:gsub('desc = "(.-)",', 'desc = LANGUAGE["'..plugins[i].KEY..'"],')
			end
		end
	end
	local file = io.open("plugins/plugins.lua", "w+")
	for s,t in pairs(cont) do
		file:write(string.format('%s\n', tostring(t)))
	end
	file:close()
	dofile("plugins/plugins.lua")--Official
	if #plugins > 0 then table.sort(plugins, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end
end

function plugins_online2()

	files.delete("ux0:data/AUTOPLUGIN2/lang/Langdatabase.lua")
	files.delete("ux0:data/AUTOPLUGIN2/plugins/plugins.lua")
	files.delete("ux0:data/AUTOPLUGIN2/plugins/plugins_psp.lua")

	if back then back:blit(0,0) end
		message_wait()
	os.delay(500)

	buttons.homepopup(0)

	local onNetGetFileOld = onNetGetFile
	onNetGetFile = nil
	__file = "Langdatabase.lua"
	http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/Translations/Langdatabase.lua", APP_REPO, APP_PROJECT), "ux0:data/AUTOPLUGIN2/lang/Langdatabase.lua")

	if files.exists("ux0:data/AUTOPLUGIN2/lang/Langdatabase.lua") then
		dofile("ux0:data/AUTOPLUGIN2/lang/Langdatabase.lua")
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"].."\n\n"..LANGUAGE["UPDATE_WIFI_IS_ON"])
		return
	end

	local tmpss = {}
	local __flag = false
	if #Online_Langs > 0 then

		for i=1,#Langs do

			for j=1,#Online_Langs do
				if string.upper(Langs[i].id) == string.upper(Online_Langs[j].id) then
					if tonumber(Langs[i].version) < tonumber(Online_Langs[j].version) then
						--if os.message("bajar si o no ?\n"..Online_Langs[j].id,1) == 1 then
						__file = Online_Langs[j].id
						--os.message("Online_Langs\n"..Online_Langs[j].id)
						if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/lang/%s.lua", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Langs[j].id), "lang/"..Online_Langs[j].id..".lua").success then
							Langs[i] = Online_Langs[j]
							table.insert(tmpss,Langs[i])
							__flag = true
						end
					end
				end
			end

		end
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"])
		return
	end--Online_Langs > 0

	local tmps = {}
	for i=1,#Online_Langs do
		local __find = false
		for j=1,#Langs do
			if string.upper(Online_Langs[i].id) == string.upper(Langs[j].id) then
				__find = true
				break
			end
		end
		if not __find then
			--if os.message("Bajar si o no ?\n"..Online_Langs[i].id,1) == 1 then
			__file = Online_Langs[i].id
			if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/lang/%s.lua", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Langs[i].id), "lang/"..Online_Langs[i].id..".lua").success then
				--os.message("Online_Langs 2\n"..Online_Langs[i].id)
				table.insert(tmps, { line = i })
				__flag = true
			end
		end

	end

	__file = ""
	for i=1,#tmps do
		table.insert( Langs, Online_Langs[tmps[i].line] )
		Langs[#Langs].new = true
		table.insert(tmpss,Langs[#Langs])
	end

	if __flag then
		if #Langs > 1 then table.sort(Langs ,function (a,b) return string.lower(a.id)<string.lower(b.id) end) end
		update_database("lang/Langdatabase.lua",Langs)
	else
		dofile("lang/Langdatabase.lua")--Official
		load_translates()
	end

	local tmpss = {}

	onNetGetFile = onNetGetFileOld

	__file = "Database Plugins"
	http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/plugins/plugins.lua", APP_REPO, APP_PROJECT), "ux0:data/AUTOPLUGIN2/plugins/plugins.lua")

	if files.exists("ux0:data/AUTOPLUGIN2/plugins/plugins.lua") then
		dofile("ux0:data/AUTOPLUGIN2/plugins/plugins.lua")
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"].."\n\n"..LANGUAGE["UPDATE_WIFI_IS_ON"])
		return
	end

	local __flag = false
	if #Online_Plugins > 0 then

		for i=1,#plugins do

			plugins[i].install = true

			for j=1,#Online_Plugins do
				if string.upper(plugins[i].KEY) == string.upper(Online_Plugins[j].KEY) then

					if tonumber(plugins[i].version) < tonumber(Online_Plugins[j].version) then

						if back2 then back2:blit(0,0) end
						os.delay(350)

						__file = Online_Plugins[j].name
						--os.message("Plugin\n"..Online_Plugins[j].name)

						local vitacheat_path = nil
						if Online_Plugins[j].path:lower() == "vitacheat360.skprx" then vitacheat_path = "vitacheat360"
						elseif Online_Plugins[j].path:lower() == "vitacheat.skprx" then vitacheat_path = "vitacheat365" end

						if vitacheat_path != nil then
							if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s/vitacheat.suprx", APP_REPO, APP_PROJECT, APP_FOLDER, vitacheat_path),
								path_plugins..vitacheat_path.."/vitacheat.suprx").success then

								if back2 then back2:blit(0,0) end
									message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..vitacheat_path)
								os.delay(1500)

							end
						end
						
						--if os.message("Update bajar si o no ?\n"..Online_Plugins[j].name,1) == 1 then
						--Lo mejor es poner ruta a project/resources/plugins
						--os.message("Try Plugin\n"..Online_Plugins[j].path)
						if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[j].path), path_plugins..Online_Plugins[j].path).success then

							cont_global:set(tonumber(cont_global:get())-1)

							--os.message("Done Plugin\n"..Online_Plugins[j].path)

							if Online_Plugins[j].path2 then
								http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[j].path2), path_plugins..Online_Plugins[j].path2)
							end

							if Online_Plugins[j].config and not files.exists("ur0:tai/"..Online_Plugins[j].config) then
								http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[j].config), path_plugins..Online_Plugins[j].config)
							end

							if back2 then back2:blit(0,0) end
								message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_Plugins[j].name)
							os.delay(1500)

							plugins[i] = Online_Plugins[j]
							table.insert(tmpss,plugins[i])
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

	--Plugins Nuevos
	local tmps = {}
	for i=1,#Online_Plugins do
		local _find = false
		for j=1,#plugins do
			if string.upper(Online_Plugins[i].KEY) == string.upper(plugins[j].KEY) then
				_find = true
				break
			end
		end
		if not _find then
			--if os.message("Nuevo bajar si o no ?\n"..Online_Plugins[i].name,1) == 1 then

			if back2 then back2:blit(0,0) end
			os.delay(350)

			__file = Online_Plugins[i].name

			--os.message("Try New Plugin\n"..Online_Plugins[i].path)
			if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[i].path), path_plugins..Online_Plugins[i].path).success then

				cont_global:set(tonumber(cont_global:get())-1)

				--os.message("Done New Plugin\n"..Online_Plugins[i].path)

				if Online_Plugins[i].path2 then
					http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[i].path2), path_plugins..Online_Plugins[i].path2)
				end
				if Online_Plugins[i].config and not files.exists("ur0:tai/"..Online_Plugins[i].config) then
					http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Plugins[i].config), path_plugins..Online_Plugins[i].config)
				end

				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_Plugins[i].name)
				os.delay(1500)

				table.insert(tmps, { line = i })
				__flag = true
			end
		end

	end

	for i=1,#tmps do
		table.insert( plugins, Online_Plugins[tmps[i].line] )
		plugins[#plugins].new = true
		plugins[#plugins].install = true
		table.insert(tmpss,plugins[#plugins])
	end

	__file = ""
	if __flag then
		if #plugins > 0 then table.sort(plugins ,function (a,b) return string.lower(a.name)<string.lower(b.name) end) end
		update_database2("plugins/plugins.lua",plugins)
	end

	buttons.homepopup(1)

	local maxim,y1 = 10,85
	local scroll = newScroll(tmpss,maxim)
	table.sort(tmpss ,function (a,b) return string.lower(a.name)<string.lower(b.name) end)

	while true do
		buttons.read()

		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_TITLE_PLUGINS_ONLINE"],1.2,color.white,0x0,__ACENTER)

		if scroll.maxim > 0 then

			local y = y1
			for i=scroll.ini,scroll.lim do

				if i == scroll.sel then draw.offsetgradrect(17,y-12,938,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

				screen.print(30,y, tmpss[i].name, 1.0, color.white,0x0)
				if tmpss[i].new then
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
