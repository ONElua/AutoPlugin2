--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function update_database3(database,tb1,tb2)

	local file = io.open(database, "w+")

    file:write("pluginsP = {\n")

	for s,t in pairs(tb1) do
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
	
	file:write("psp_plugins = {\n")

	for s,t in pairs(tb2) do
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


	dofile("plugins/plugins_psp.lua")--Official

	for i=1,#pluginsP do
		for j=1, #cont do
			if string.find(cont[j], pluginsP[i].KEY, 1, true) then
				cont[j] = cont[j]:gsub('desc = "(.-)",', 'desc = LANGUAGE["'..pluginsP[i].KEY..'"],')
			end
		end
	end

	for i=1,#psp_plugins do
		for j=1, #cont do
			if string.find(cont[j], psp_plugins[i].KEY, 1, true) then
				cont[j] = cont[j]:gsub('desc = "(.-)",', 'desc = LANGUAGE["'..psp_plugins[i].KEY..'"],')
			end
		end
	end

	local file = io.open("plugins/plugins_psp.lua", "w+")
	for s,t in pairs(cont) do
		file:write(string.format('%s\n', tostring(t)))
	end
	file:close()

	dofile("plugins/plugins_psp.lua")--Official
	if #pluginsP > 0 then table.sort(pluginsP, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end
	if #psp_plugins > 0 then table.sort(psp_plugins, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end
end

function plugins_online3()

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
						__file = Online_Langs[j].id
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
			__file = Online_Langs[i].id
			if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/lang/%s.lua", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Langs[i].id), "lang/"..Online_Langs[i].id..".lua").success then
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
	http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/plugins/plugins_psp.lua", APP_REPO, APP_PROJECT), "ux0:data/AUTOPLUGIN2/plugins/plugins_psp.lua")

	if files.exists("ux0:data/AUTOPLUGIN2/plugins/plugins_psp.lua") then
		dofile("ux0:data/AUTOPLUGIN2/plugins/plugins_psp.lua")
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"].."\n\n"..LANGUAGE["UPDATE_WIFI_IS_ON"])
		return
	end

	local __flag = false

	--Plugins for PSP (Adrenaline)
	if #Online_pluginsP > 0 then
		for i=1,#pluginsP do
			pluginsP[i].install = true

			for j=1,#Online_pluginsP do
				if string.upper(pluginsP[i].KEY) == string.upper(Online_pluginsP[j].KEY) then

					if tonumber(pluginsP[i].version) < tonumber(Online_pluginsP[j].version) then

						if back2 then back2:blit(0,0) end
						os.delay(350)

						__file = Online_pluginsP[j].name
						if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_pluginsP[j].name), "resources/plugins_psp/"..Online_pluginsP[j].name).success then
							--os.message(Online_pluginsP[j].name)
							if Online_pluginsP[j].config then
								http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_pluginsP[j].config), "resources/plugins_psp/"..Online_pluginsP[j].config)
							end

							if back2 then back2:blit(0,0) end
								message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_pluginsP[j].name)
								--os.message(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_psp_plugins[j].name)
							os.delay(1500)

							pluginsP[i] = Online_pluginsP[j]
							table.insert(tmpss,pluginsP[i])
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
			psp_plugins[i].install = true

			for j=1,#Online_psp_plugins do
				if string.upper(psp_plugins[i].KEY) == string.upper(Online_psp_plugins[j].KEY) then

					if tonumber(psp_plugins[i].version) < tonumber(Online_psp_plugins[j].version) then

						if back2 then back2:blit(0,0) end
						os.delay(350)

						__file = Online_psp_plugins[j].name

						if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/controls_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_psp_plugins[j].path), "resources/plugins_psp/controls_psp/"..Online_psp_plugins[j].path).success then

							if back2 then back2:blit(0,0) end
								message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_psp_plugins[j].name)
							os.delay(1500)

							psp_plugins[i] = Online_psp_plugins[j]
							table.insert(tmpss,psp_plugins[i])
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


	local tmps,tmps2 = {},{}

	--Plugins for PSP
	for i=1,#Online_pluginsP do
		local _find = false
		local sifind = 0
		for j=1,#pluginsP do
			if string.upper(Online_pluginsP[i].KEY) == string.upper(pluginsP[j].KEY) then
				_find = true
				break
			end
		end
		if not _find then

			if back2 then back2:blit(0,0) end
			os.delay(350)

			__file = Online_pluginsP[i].name

			if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_pluginsP[i].name), "resources/plugins_psp/"..Online_pluginsP[i].name).success then

				if Online_pluginsP[i].config then
					http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_pluginsP[i].config), "resources/plugins_psp/"..Online_pluginsP[i].config)
				end

				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_pluginsP[i].name)
					--os.message(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_psp_plugins[i].name)
				os.delay(1500)

				table.insert(tmps, { line = i })
				__flag = true
			end
		end
	end

	--Plugins for Remastered Controls
	for i=1,#Online_psp_plugins do
		local _find = false
		local sifind = 0
		for j=1,#psp_plugins do
			
			if string.upper(Online_psp_plugins[i].KEY) == string.upper(psp_plugins[j].KEY) then
				_find = true
				break
			end
		end
		if not _find then

			if back2 then back2:blit(0,0) end
			os.delay(350)

			__file = Online_psp_plugins[i].name

			if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/controls_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_psp_plugins[i].path), "resources/plugins_psp/controls_psp/"..Online_psp_plugins[i].path).success then

				if Online_psp_plugins[i].config then
					http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/resources/plugins_psp/controls_psp/%s", APP_REPO, APP_PROJECT, APP_FOLDER, Online_psp_plugins[i].config), "resources/plugins_psp/controls_psp/"..Online_psp_plugins[i].config)
				end

				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_psp_plugins[i].name)
					--os.message(LANGUAGE["UPDATE_PLUGIN"].."\n\n"..Online_psp_plugins[i].name)
				os.delay(1500)

				table.insert(tmps2, { line = i })
				__flag = true
			end
		end
	end

	if tmps then
		for i=1,#tmps do
			table.insert( pluginsP, Online_pluginsP[tmps[i].line] )
			pluginsP[#pluginsP].new = true
			pluginsP[#pluginsP].install = true
			table.insert(tmpss,pluginsP[#pluginsP])
		end
	end
	if tmps2 then
		for i=1,#tmps2 do
			table.insert( psp_plugins, Online_psp_plugins[tmps2[i].line] )
			psp_plugins[#psp_plugins].new = true
			psp_plugins[#psp_plugins].install = true
			table.insert(tmpss,psp_plugins[#psp_plugins])
		end
	end

	__file = ""
	if __flag then
		update_database3("plugins/plugins_psp.lua",pluginsP,psp_plugins)
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
