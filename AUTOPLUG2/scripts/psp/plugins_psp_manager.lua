--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]


--path "pspemu/seplugins/game.txt" plugins_manager
function read_configs_all()

	local configs = {"vsh.txt","game.txt","pops.txt"}

	for i=1, #plugins_manager do

		for j=1,#configs do

			if files.exists(plugins_manager[i].mount.."pspemu/seplugins/"..configs[j]) then

				for line in io.lines(plugins_manager[i].mount.."pspemu/seplugins/"..configs[j]) do

					if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13

					pathp,status = line:match("(.+) (.+)")
					if pathp then

						local plugs = {}
						plugs.exists = files.exists(plugins_manager[i].mount.."pspemu/seplugins/"..configs[j])
						plugs.path = pathp
						plugs.status = tonumber(status) or 0

						if configs[j] == "vsh.txt" then
							table.insert(plugins_manager[i][1],plugs)
						elseif configs[j] == "game.txt" then
							table.insert(plugins_manager[i][2],plugs)
						elseif configs[j] == "pops.txt" then
							table.insert(plugins_manager[i][3],plugs)
						end

					end
				end--for

			end

		if configs[j] == "vsh.txt" then
			plugins_manager[i][1].config = "vsh"
		elseif configs[j] == "game.txt" then
			plugins_manager[i][2].config = "game"
		elseif configs[j] == "pops.txt" then
			plugins_manager[i][3].config = "pops"
		end

		end--for configs

	end

	--Debugger
--[[
	for i=1,#plugins_manager do
		for j=1,#configs do
			os.message(plugins_manager[i].mount.." Config: "..plugins_manager[i][j].config.."\n\nTotal: "..#plugins_manager[i][j])
		end
	end
]]

end

function enable_disable_psp_plugin(device,obj,install)

	--add vsh.txt & game.txt
	local nlinea, cont, _find, file_txt = 0,0,false, {}
	local find_obj = obj.path

	for line in io.lines(device) do
		cont += 1
		if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13
		table.insert(file_txt,line)

		pathp,status = line:match("(.+) (.+)")

		if pathp then
			if pathp:lower() == find_obj:lower() then
				_find = true
				nlinea = cont
			end
		end

	end

	if install == 1 then
		if _find then
			file_txt[nlinea] = find_obj.." 1"
		else
			table.insert(file_txt, find_obj.." 1")
		end
	else
		file_txt[nlinea] = find_obj.." 0"
	end

	local fp = io.open(device, "w+")
	for s,t in pairs(file_txt) do
		fp:write(string.format('%s\n', tostring(t)))
	end
	fp:close()

end

function psp_plugins_manager()

	read_configs_all()

	local selector,conf,limit = 1,1,8

	local scroll = newScroll(plugins_manager[selector][conf], limit)
	local xscroll = 10

	while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["PSP_PLUGINS_MANAGER"],1.2,color.white,0x0,__ACENTER)
		if plugins_manager[selector][conf].config then
			screen.print(13, 65, "<< "..plugins_manager[selector][conf].config.." ("..scroll.maxim..")  >>", 1, color.yellow, 0x0)
		end

		--Partitions
		local xRoot = 700
		local w = (955-xRoot)/#PMounts
		for i=1, #PMounts do
			if selector == i then
				draw.fillrect(xRoot,56,w,42, color.green:a(90))
			end
			screen.print(xRoot+(w/2), 65, PMounts[i], 1, color.white, color.blue, __ACENTER)
			xRoot += w
		end

		if scroll.maxim > 0 then
		
			--List of Plugins
			local y = 110
			for i=scroll.ini, scroll.lim do

				if i == scroll.sel then draw.offsetgradrect(15,y-10,945,38,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

				if plugins_manager[selector][conf][i].exists then cc = color.white else cc = color.yellow end
				
				
				if plugins_manager[selector][conf][i].inst then
					screen.print(55,y, ">> "..plugins_manager[selector][conf][i].path,1,color.green,0x0)
				else
					screen.print(55,y, plugins_manager[selector][conf][i].path,1,cc,0x0)
				end


				if plugins_manager[selector][conf][i].status == 1 then
					if dotg then dotg:blit(925,y-1) end
				else
					if doty then doty:blit(925,y-1) end
				end

				y+=35
			end

			--Bar Scroll
			local ybar, h = 103, (limit*35)-2
			draw.fillrect(3, ybar-2, 8, h, color.shine)
			local pos_height = math.max(h/scroll.maxim, limit)
			draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))

		else
			screen.print(480,230,LANGUAGE["UNINSTALLP_NO_PLUGINS"], 1, color.white, color.red, __ACENTER)
		end

		if buttonskey2 then buttonskey2:blitsprite(900,448,2) end
		if buttonskey2 then buttonskey2:blitsprite(930,448,3) end
		screen.print(895,450,LANGUAGE["PSPCTRLS_LR_SWAP"],1,color.white,color.black,__ARIGHT)

		if buttonskey2 then buttonskey2:blitsprite(900,472,0) end
		if buttonskey2 then buttonskey2:blitsprite(930,472,1) end
		screen.print(895,475,LANGUAGE["UNINSTALLP_LEFTRIGHT_CONFIG"],1,color.white,color.black,__ARIGHT)

		if buttonskey then buttonskey:blitsprite(10,448,__TRIANGLE) end
		screen.print(45,450,LANGUAGE["UNINSTALL_PLUGIN"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,472,__SQUARE) end
		screen.print(45,475,LANGUAGE["MARK_PLUGINS"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(5,498,0) end
		screen.print(45,500,LANGUAGE["CLEAN_PLUGINS"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(45,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.cancel then break end

		--L/R Swap Mounts
		if buttons.released.l or buttons.released.r then
			if buttons.released.l then selector -= 1 else selector += 1 end
			if selector > #plugins_manager then selector = 1
			elseif selector < 1 then selector = #plugins_manager end
			conf = 1
			scroll = newScroll(plugins_manager[selector][conf], limit)
		end

		--Left/Right Swap Configs
		if buttons.left or buttons.right then
			if buttons.left then conf -= 1 else conf += 1 end
			if conf > 3 then conf = 1
			elseif conf < 1 then conf = 3 end
			scroll = newScroll(plugins_manager[selector][conf], limit)
		end

		--Exit
		if buttons.start then
			exit_bye_bye()
		end

		vol_mp3()

		if scroll.maxim > 0 then

			if buttons.up or buttons.analogly < -60 then
				if scroll:up() then xscroll = 10 end
			end
			if buttons.down or buttons.analogly > 60 then
				if scroll:down() then xscroll = 10 end
			end

			if buttons.accept then

				local device_path = PMounts[selector].."pspemu/seplugins/"..plugins_manager[selector][conf].config..".txt"

				if not files.exists(device_path) then
					files.new(device_path)
				end

				plugins_manager[selector][conf][scroll.sel].inst = true

				for i=1, scroll.maxim do
					if plugins_manager[selector][conf][i].inst then

						if plugins_manager[selector][conf][i].status == 0 then

							enable_disable_psp_plugin(device_path, plugins_manager[selector][conf][i], 1)
							plugins_manager[selector][conf][i].status = 1
							plugins_manager[selector][conf][i].inst = false

							if back2 then back2:blit(0,0) end
								message_wait(plugins_manager[selector][conf][i].path.."\n\n"..LANGUAGE["STRING_INSTALLED"])
							os.delay(750)
						end
					end
				end

			end
			
			--Mark/Unmark
			if buttons.square then
				plugins_manager[selector][conf][scroll.sel].inst = not plugins_manager[selector][conf][scroll.sel].inst
			end

			--Clean selected
			if buttons.select then
				for i=1,scroll.maxim do
					plugins_manager[selector][conf][i].inst = false
				end
			end


			--Pendiente README para Remastered Plugins for PSP
			--link = "https://github.com/TheOfficialFloW/RemasteredControls/raw/master/README.md",

			--disable plugins
			if buttons.triangle then

				plugins_manager[selector][conf][scroll.sel].inst = true

				local device_path = PMounts[selector].."pspemu/seplugins/"..plugins_manager[selector][conf].config..".txt"
				for i=1,scroll.maxim do
					if plugins_manager[selector][conf][i].inst then
						if files.exists(device_path) and plugins_manager[selector][conf][i].status == 1 then

							enable_disable_psp_plugin(device_path, plugins_manager[selector][conf][i], 0)
							plugins_manager[selector][conf][i].status = 0
							plugins_manager[selector][conf][i].inst = false

							if back2 then back2:blit(0,0) end
								message_wait(plugins_manager[selector][conf][i].path.."\n\n"..LANGUAGE["STRING_UNINSTALLED"])
							os.delay(750)
						end
					end
				end

			end

		end

	end

end
