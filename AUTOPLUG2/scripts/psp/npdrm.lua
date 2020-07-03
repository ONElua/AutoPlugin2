--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function insert_plugin(path)

	local nlinea, cont, _find, file_txt = 0,0,false, {}
	local find_obj = "ms0:/seplugins/npdrm_free.prx"

	for line in io.lines(path) do
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

	local fp = io.open(path, "w+")
	for s,t in pairs(file_txt) do
		fp:write(string.format('%s\n', tostring(t)))
	end
	fp:close()

end

function delete_plugin(path)

	--del vsh.txt & game.txt
	local nlinea, cont, _find, file_txt = 0,0,false, {}
	local find_obj = "ms0:/seplugins/npdrm_free.prx"

	for line in io.lines(path) do
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

	local fp = io.open(path, "w+")
	for s,t in pairs(file_txt) do
		fp:write(string.format('%s\n', tostring(t)))
	end
	fp:close()

end

function npdrm_free()

	local selector,limit = 1,8
	local npdrm_p = {

		--npdrm free game.txt
		{ name = "Npdrm free from qwikrazor87",		path = "npdrm_free.prx" },
	}
	if #npdrm_p < limit then limit = #npdrm_p end
	local scroll = newScroll(npdrm_p, limit)
	local xscroll = 10

	while true do
		buttons.read()
		if back2 then back2:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["NPDRMFREE_TITLE"],1.2,color.white,0x0,__ACENTER)

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

			if npdrm_p[i].inst then ccolor = color.green else ccolor = color.white end
			screen.print(25,y, npdrm_p[i].name,1,ccolor,0x0)

			y+=35
		end

		--Bar Scroll
		local ybar, h = 103, (limit*35)-2
		draw.fillrect(3, ybar-2, 8, h, color.shine)
		local pos_height = math.max(h/scroll.maxim, limit)
		draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))

		if screen.textwidth(LANGUAGE["MENU_PSP_NPDRMFREE_DESC"]) > 925 then
			xscroll = screen.print(xscroll, 400, LANGUAGE["MENU_PSP_NPDRMFREE_DESC"],1,color.white,color.blue,__SLEFT,935)
		else
			screen.print(480, 400, LANGUAGE["MENU_PSP_NPDRMFREE_DESC"],1,color.white,color.blue,__ACENTER)
		end

		if buttonskey2 then buttonskey2:blitsprite(900,448,2) end
		if buttonskey2 then buttonskey2:blitsprite(930,448,3) end
		screen.print(895,450,LANGUAGE["PSPCTRLS_LR_SWAP"],1,color.white,color.black,__ARIGHT)

		if buttonskey then buttonskey:blitsprite(10,448,__TRIANGLE) end
		screen.print(40,450,LANGUAGE["UNINSTALL_PLUGIN"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,472,saccept) end
		screen.print(40,475,LANGUAGE["NPDRMFREE_INSTALL"],1,color.white,color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(40,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

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
			exit_bye_bye()
		end

		if scroll.maxim > 0 then

			if buttons.up or buttons.analogly < -60 then
				if scroll:up() then xscroll = 10 end
			end
			if buttons.down or buttons.analogly > 60 then
				if scroll:down() then xscroll = 10 end
			end	

			if buttons.left or buttons.right then xscroll = 10 end

			--install plugin
			if buttons.accept then
				if not change then buttons.homepopup(0) end

					files.copy("resources/pkgj/npdrm_free.prx", PMounts[selector].."pspemu/seplugins/")
					if files.exists(PMounts[selector].."pspemu/seplugins/npdrm_free.prx") then
						if back2 then back2:blit(0,0) end
							message_wait(LANGUAGE["NPDRMFREE_INSTALLED"])
						os.delay(1500)
					end

					--Update vsh.txt
					if files.exists(PMounts[selector].."pspemu/seplugins/vsh.txt") then
						insert_plugin(PMounts[selector].."pspemu/seplugins/vsh.txt")
					else
						files.copy("resources/pkgj/vsh.txt", PMounts[selector].."pspemu/seplugins/")
					end
					if back2 then back2:blit(0,0) end
						message_wait(LANGUAGE["NPDRMFREE_VSH_UPDATED"])
					os.delay(1500)

					--Update game.txt
					if files.exists(PMounts[selector].."pspemu/seplugins/game.txt") then
						insert_plugin(PMounts[selector].."pspemu/seplugins/game.txt")
	
					else
						files.copy("resources/pkgj/game.txt", PMounts[selector].."pspemu/seplugins/")
					end
					if back2 then back2:blit(0,0) end
						message_wait(LANGUAGE["NPDRMFREE_GAME_UPDATED"])
					os.delay(1500)
				if not change then buttons.homepopup(1) end
			end

			--del plugins
			if buttons.triangle then

				if files.exists(PMounts[selector].."pspemu/seplugins/vsh.txt") then
					delete_plugin(PMounts[selector].."pspemu/seplugins/vsh.txt")
					if back2 then back2:blit(0,0) end
						message_wait(npdrm_p[scroll.sel].name.."\n\n"..LANGUAGE["STRING_UNINSTALLED"])
					os.delay(750)
				end

				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["NPDRMFREE_VSH_UPDATED"])
				os.delay(1500)

				if files.exists(PMounts[selector].."pspemu/seplugins/game.txt") then
					delete_plugin(PMounts[selector].."pspemu/seplugins/game.txt")
					if back2 then back2:blit(0,0) end
						message_wait(npdrm_p[scroll.sel].name.."\n\n"..LANGUAGE["STRING_UNINSTALLED"])
					os.delay(750)
				end

				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["NPDRMFREE_GAME_UPDATED"])
				os.delay(1500)

			end

		end

	end

end
