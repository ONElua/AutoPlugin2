--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function add_psp_plugin(device,obj)

	--install plugin
	files.copy("resources/plugins_psp/"..obj.name, device.."pspemu/"..obj.path)

	if obj.config then
		files.copy("resources/plugins_psp/"..obj.config, device.."pspemu/"..obj.path)
	end

	--add vsh.txt & game.txt
	local nlinea, cont, _find, file_txt = 0,0,false, {}
	local find_obj = "ms0:/"..obj.path..obj.name

	for line in io.lines(device.."pspemu/seplugins/"..obj.txt) do
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

	if _find then
		file_txt[nlinea] = find_obj.." 1"
	else
		table.insert(file_txt, find_obj.." 1")
	end

	local fp = io.open(device.."pspemu/seplugins/"..obj.txt, "w+")
	for s,t in pairs(file_txt) do
		fp:write(string.format('%s\n', tostring(t)))
	end
	fp:close()

end

function del_psp_plugin(device,obj)

	--del vsh.txt & game.txt
	local nlinea, cont, _find, file_txt = 0,0,false, {}
	local find_obj = "ms0:/"..obj.path..obj.name

	for line in io.lines(device.."pspemu/seplugins/"..obj.txt) do
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

	if _find then
		file_txt[nlinea] = find_obj.." 0"
	end

	local fp = io.open(device.."pspemu/seplugins/"..obj.txt, "w+")
	for s,t in pairs(file_txt) do
		fp:write(string.format('%s\n', tostring(t)))
	end
	fp:close()

end

function pluginsPSP()

	local selector,limit = 1,8
	local pluginsP = {

		{	showname = "CXMB", name="cxmb.prx", path = "cxmb/", desc = LANGUAGE["CXMB_DESC"], txt = "vsh.txt", },
		{	showname = "GTA Native Resolution Patch v0.2", name = "gta_native.prx",	path = "seplugins/", desc = LANGUAGE["GTA_PATCH_DESC"], txt = "game.txt", },
		{	showname = "Camera Patch Lite", name = "camera_patch_lite.prx",	path = "seplugins/", desc = LANGUAGE["CAMERA_PATCH_DESC"], txt = "game.txt", config = "camera_patch_lite.ini" },
		{	showname = "Lang Swapper", name = "LangSwapper.prx",	path = "seplugins/", desc = LANGUAGE["LANGSWAPPER_DESC"], txt = "game.txt", },
		{	showname = "Category lite", name = "category_lite.prx",	path = "seplugins/", desc = LANGUAGE["CATEGORYLITE_DESC"], txt = "vsh.txt", },
		{	showname = "Kingdom Hearts: Birth By Sleep/Final Mix UNDUB", name = "bbsfmUndub.prx",	path = "seplugins/", desc = LANGUAGE["KHBBS_UNDUB_DESC"], txt = "game.txt", },

	}
	if #pluginsP < limit then limit = #pluginsP end
	local scroll = newScroll(pluginsP, limit)
	local xscroll = 10

	for i=1,scroll.maxim do
		pluginsP[i].inst = false
	end

	while true do
		buttons.read()
		if back2 then back2:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["PLUGINS_PSP_TITLE"],1.2,color.white,0x0,__ACENTER)

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

		--List of Plugins
		local y = 110
		for i=scroll.ini, scroll.lim do

			if i == scroll.sel then draw.offsetgradrect(15,y-10,945,38,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			if pluginsP[i].inst then ccolor = color.green else ccolor = color.white end
			screen.print(25,y, pluginsP[i].showname,1,ccolor,0x0)
			screen.print(950,y, "( "..pluginsP[i].txt.." )",1,ccolor,0x0,__ARIGHT)

			y+=35
		end

		--Bar Scroll
		local ybar, h = 103, (limit*35)-2
		draw.fillrect(3, ybar-2, 8, h, color.shine)
		local pos_height = math.max(h/scroll.maxim, limit)
		draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))

		if screen.textwidth(pluginsP[scroll.sel].desc) > 925 then
			xscroll = screen.print(xscroll, 400, pluginsP[scroll.sel].desc,1,color.white,color.blue,__SLEFT,935)
		else
			screen.print(480, 400, pluginsP[scroll.sel].desc,1,color.white,color.blue,__ACENTER)
		end

		if buttonskey2 then buttonskey2:blitsprite(900,448,2) end
		if buttonskey2 then buttonskey2:blitsprite(930,448,3) end
		screen.print(895,450,LANGUAGE["PSPCTRLS_LR_SWAP"],1,color.white,color.black,__ARIGHT)

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

		if buttons.released.cancel then break end

		--L/R
		if buttons.released.l or buttons.released.r then
			if buttons.released.l then selector -= 1 else selector += 1 end
			if selector > #PMounts then selector = 1
			elseif selector < 1 then selector = #PMounts end
		end

		--Exit
		if buttons.start then
			if change then ReloadConfig = false end
			if ReloadConfig then
				if os.taicfgreload() != 1 then change = true else os.message(LANGUAGE["STRINGS_CONFIG_SUCCESS"]) end
			end

			if change then
				os.message(LANGUAGE["STRING_PSVITA_RESTART"])
				os.delay(250)
				buttons.homepopup(1)
				power.restart()
			end

			os.delay(250)
			buttons.homepopup(1)
			os.exit()
		end

		if scroll.maxim > 0 then

			if buttons.left or buttons.right then xscroll = 10 end

			if buttons.up or buttons.analogly < -60 then
				if scroll:up() then xscroll = 10 end
			end
			if buttons.down or buttons.analogly > 60 then
				if scroll:down() then xscroll = 10 end
			end

			if buttons.accept then

				if not files.exists(PMounts[selector].."pspemu/seplugins/vsh.txt") then
					files.new(PMounts[selector].."pspemu/seplugins/vsh.txt")
				end
				if not files.exists(PMounts[selector].."pspemu/seplugins/game.txt") then
					files.new(PMounts[selector].."pspemu/seplugins/game.txt")
				end

				pluginsP[scroll.sel].inst = true

				for i=1, scroll.maxim do
					if pluginsP[i].inst then
						add_psp_plugin(PMounts[selector], pluginsP[i])
						if back2 then back2:blit(0,0) end
							message_wait(pluginsP[i].showname.."\n\n"..LANGUAGE["STRING_INSTALLED"])
						os.delay(750)
					end
				end

				for i=1,scroll.maxim do
					pluginsP[i].inst = false
				end

			end
			
			--Mark/Unmark
			if buttons.square then
				pluginsP[scroll.sel].inst = not pluginsP[scroll.sel].inst
			end

			--Clean selected
			if buttons.select then
				for i=1,scroll.maxim do
					pluginsP[i].inst = false
				end
			end

			--del plugins
			if buttons.triangle then

				pluginsP[scroll.sel].inst = true

				for i=1,scroll.maxim do
					if pluginsP[i].inst then
						if files.exists(PMounts[selector].."pspemu/seplugins/"..pluginsP[i].txt) then
							del_psp_plugin(PMounts[selector], pluginsP[i])
							if back2 then back2:blit(0,0) end
								message_wait(pluginsP[i].showname.."\n\n"..LANGUAGE["STRING_UNINSTALLED"])
							os.delay(750)
						end
					end					
				end
				for i=1,scroll.maxim do
					pluginsP[i].inst = false
				end

			end

		end

	end

end
