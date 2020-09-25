--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function read_configs_pspctrls(tb,tb2)

	for i=1, #PMounts do

		if files.exists(PMounts[i].."pspemu/seplugins/game.txt") then
			--game.txt
			for line in io.lines(PMounts[i].."pspemu/seplugins/game.txt") do

				if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13

				pathp,status = line:match("(.+) (.+)")
				if pathp then
					
					for j=1,#tb do

						if pathp:lower() == "ms0:/seplugins/"..tb[j].path:lower() then

							if files.exists(PMounts[i].."pspemu/seplugins/"..tb[j].path:lower()) then
								tb2[PMounts[i]..tb[j].path:lower()] = tonumber(status) or 0
								break
							end
						end
					end

				end

			end
		end


	end

end

function insert_disable_psp_plugin(device,obj,install)

	--add vsh.txt & game.txt
	local nlinea, cont, _find, file_txt = 0,0,false, {}
	local find_obj = "ms0:/seplugins/"..obj.path

	for line in io.lines(device.."pspemu/seplugins/game.txt") do
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

	local fp = io.open(device.."pspemu/seplugins/game.txt", "w+")
	for s,t in pairs(file_txt) do
		fp:write(string.format('%s\n', tostring(t)))
	end
	fp:close()

end

function psp_ctrls()

	local plugins_status={}
	read_configs_pspctrls(psp_plugins,plugins_status)

	local selector,limit = 1,8
	if #psp_plugins < limit then limit = #psp_plugins end
	local scroll = newScroll(psp_plugins, limit)
	local xscroll = 10

	for i=1,scroll.maxim do
		psp_plugins[i].inst = false
	end

	while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["PSPCTRLS_TITLE"],1.2,color.white,0x0,__ACENTER)

		screen.print(13, 65, " ("..scroll.maxim..")", 1, color.yellow, 0x0)

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

			if psp_plugins[i].inst then ccolor = color.green else ccolor = color.white end
			screen.print(25,y, psp_plugins[i].name,1,ccolor,0x0)

			if plugins_status[ PMounts[selector]..psp_plugins[i].path:lower() ] then
				if plugins_status[ PMounts[selector]..psp_plugins[i].path:lower() ] == 1 then
					if dotg then dotg:blit(925,y-1) end
			elseif plugins_status[ PMounts[selector]..psp_plugins[i].path:lower() ] == 0 then
				if doty then doty:blit(925,y-1) end
				end
			end

			y+=35
		end

		--Bar Scroll
		local ybar, h = 103, (limit*35)-2
		draw.fillrect(3, ybar-2, 8, h, color.shine)
		local pos_height = math.max(h/scroll.maxim, limit)
		draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))

		if psp_plugins[scroll.sel].desc then
			if screen.textwidth(psp_plugins[scroll.sel].desc) > 925 then
				xscroll = screen.print(xscroll, 400, psp_plugins[scroll.sel].desc,1,color.white,color.blue,__SLEFT,935)
			else
				screen.print(480, 400, psp_plugins[scroll.sel].desc,1,color.white,color.blue,__ACENTER)
			end
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

		if buttons.cancel then break end

		--L/R
		if buttons.released.l or buttons.released.r then
			if buttons.released.l then selector -= 1 else selector += 1 end
			if selector > #PMounts then selector = 1
			elseif selector < 1 then selector = #PMounts end
			for i=1,scroll.maxim do
				psp_plugins[i].inst = false
			end
			scroll = newScroll(psp_plugins, limit)
		end

		--Exit
		if buttons.start then
			exit_bye_bye()
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

				if not files.exists(PMounts[selector].."pspemu/seplugins/game.txt") then
					files.new(PMounts[selector].."pspemu/seplugins/game.txt")
				end

				psp_plugins[scroll.sel].inst = true

				for i=1, scroll.maxim do
					if psp_plugins[i].inst then

						--install plugin
						files.copy("resources/plugins_psp/controls_psp/"..psp_plugins[i].path, PMounts[selector].."pspemu/seplugins/")

						if plugins_status[ PMounts[selector]..psp_plugins[i].path:lower() ] == 0 or not plugins_status[ PMounts[selector]..psp_plugins[i].path:lower() ] then

							insert_disable_psp_plugin(PMounts[selector], psp_plugins[i],1)
							plugins_status[ PMounts[selector]..psp_plugins[i].path:lower() ] = 1

							if back2 then back2:blit(0,0) end
								message_wait(psp_plugins[i].name.."\n\n"..LANGUAGE["STRING_INSTALLED"])
							os.delay(750)
						end
					end
				end

				for i=1,scroll.maxim do
					psp_plugins[i].inst = false
				end

			end
			
			--Mark/Unmark
			if buttons.square then
				psp_plugins[scroll.sel].inst = not psp_plugins[scroll.sel].inst
			end

			--Clean selected
			if buttons.select then
				for i=1,scroll.maxim do
					psp_plugins[i].inst = false
				end
			end


			--Pendiente README para Remastered Plugins for PSP
			--link = "https://github.com/TheOfficialFloW/RemasteredControls/raw/master/README.md",

			--disable plugins
			if buttons.triangle then

				psp_plugins[scroll.sel].inst = true

				for i=1,scroll.maxim do
					if psp_plugins[i].inst then
						if files.exists(PMounts[selector].."pspemu/seplugins/game.txt") and plugins_status[ PMounts[selector]..psp_plugins[i].path:lower() ] == 1 then

							insert_disable_psp_plugin(PMounts[selector], psp_plugins[i],0)
							plugins_status[ PMounts[selector]..psp_plugins[i].path:lower() ] = 0
							psp_plugins[i].inst = false

							if back2 then back2:blit(0,0) end
								message_wait(psp_plugins[i].name.."\n\n"..LANGUAGE["STRING_UNINSTALLED"])
							os.delay(750)
						end
					end
				end

				for i=1,scroll.maxim do
					psp_plugins[i].inst = false
				end

			end

		end

	end

end
