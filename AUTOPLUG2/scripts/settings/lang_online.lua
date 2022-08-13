--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

dofile("lang/Langdatabase.lua")--Official

function update_database(database,tb)

	local file = io.open(database, "w+")

    file:write("Langs = {\n")

	for s,t in pairs(tb) do
		file:write(string.format('{ id =  "%s",		version = "%s",		author =  "%s" },\n', tostring(t.id), tostring(t.version), tostring(t.author)))
	end

	file:write("}\n")
	file:close()
	dofile("lang/Langdatabase.lua")--Official
	load_translates()
end

function lang_online()

	files.delete("ux0:data/AUTOPLUGIN2/lang/Langdatabase.lua")
	files.delete("ux0:data/AUTOPLUGIN2/plugins/plugins.lua")
	files.delete("ux0:data/AUTOPLUGIN2/plugins/plugins_psp.lua")

	if back then back:blit(0,0) end
		message_wait()
	os.delay(500)

	local tmpss = {}

	__file = "Langdatabase.lua"
	local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/Translations/Langdatabase.lua", APP_REPO, APP_PROJECT), "ux0:data/AUTOPLUGIN2/lang/Langdatabase.lua")

if res and res.success and files.exists("ux0:data/AUTOPLUGIN2/lang/Langdatabase.lua") then
		dofile("ux0:data/AUTOPLUGIN2/lang/Langdatabase.lua")
	else
		os.message(LANGUAGE["LANG_ONLINE_FAILDB"].."\n\n"..LANGUAGE["UPDATE_WIFI_IS_ON"])
		return
	end

	local __flag = false
	if #Online_Langs > 0 then

		for i=1,#Langs do

			for j=1,#Online_Langs do
				if string.upper(Langs[i].id) == string.upper(Online_Langs[j].id) then
					if tonumber(Langs[i].version) < tonumber(Online_Langs[j].version) then
						--if os.message("bajar si o no ?\n"..Online_Langs[j].id,1) == 1 then
						__file = Online_Langs[j].id
						if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/lang/%s.lua", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Langs[j].id), "lang/"..Online_Langs[j].id..".lua").success then
							if back2 then back2:blit(0,0) end
								message_wait(LANGUAGE["STRING_INSTALLED"].."\n\n"..Online_Langs[j].id.."\n")
							os.delay(1500)

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
			--if os.message("BBajar si o no ?\n"..Online_Langs[i].id,1) == 1 then
			__file = Online_Langs[i].id
			if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/%s/lang/%s.lua", APP_REPO, APP_PROJECT, APP_FOLDER, Online_Langs[i].id), "lang/"..Online_Langs[i].id..".lua").success then
				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["STRING_INSTALLED"].."\n\n"..Online_Langs[i].id)
				os.delay(1500)
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
	end

	local maxim,y1 = 8,85
	local scroll = newScroll(tmpss,maxim)
	table.sort(tmpss ,function (a,b) return string.lower(a.id)<string.lower(b.id) end)

	while true do
		buttons.read()

		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_TITLE_LANG_ONLINE"],1.2,color.white,0x0,__ACENTER)

		if scroll.maxim > 0 then

			local y = y1
			for i=scroll.ini,scroll.lim do

				if i == scroll.sel then draw.offsetgradrect(17,y-12,938,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

				screen.print(30,y, tmpss[i].id.." v "..tmpss[i].version, 1.2, color.white,0x0)
				
				if tmpss[i].new then
					screen.print(945,y,LANGUAGE["LANG_FILE_NEW"],1.2,color.green,0x0,__ARIGHT)
				else
					screen.print(945,y,LANGUAGE["LANG_FILE_UPDATE"],1.2,color.green,0x0,__ARIGHT)
				end

				y+= 45

			end--for

			--Bar Scroll
			local ybar, h = y1-10, (maxim*45)-4
			if scroll.maxim >= maxim then -- Draw Scroll Bar
				draw.fillrect(3, ybar-3, 8, h, color.shine)
				local pos_height = math.max(h/scroll.maxim, maxim)
				draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))
			end

		else
			screen.print(480,230, LANGUAGE["LANGUAGE_NO_UPDATE"], 1, color.white, color.red, __ACENTER)
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
