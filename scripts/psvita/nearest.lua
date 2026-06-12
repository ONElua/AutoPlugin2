function search_gameid()

	local descript = LANGUAGE["MENU_PSVITA_INSTALL_NEAREST"]
	for j=1,#plugins do
		if "INSTALLP_DESC_VITANEARESTN" == plugins[j].KEY then
			descript = plugins[j].name
		end
	end

	local list_tmp = game.list(__GAME_LIST_APP)
	local tmp = {
		title = "ALL", id = "ALL"
	}
	
	if list_tmp then
		table.sort(list_tmp, function (a,b) return string.lower(a.title)<string.lower(b.title) end)
		table.insert(list_tmp, 1, tmp)
	end

	local limit = 9
	local scroll = newScroll(list_tmp,limit)
	local xscroll = 13

	buttons.interval(10,6)
	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.fillrect(0,0,960,55,color.black:a(100))
		draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_PSVITA_INSTALL_NEAREST"],1.2,color.white,0x0,__ACENTER)

		local y = 65
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(5,y-12,943,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
			
			if screen.textwidth(list_tmp[i].title) > 925 then
				xscroll = screen.print(xscroll, y, list_tmp[i].title,1,color.white,color.blue,__SLEFT,935)
			else
				screen.print(13, y, list_tmp[i].title,1,color.white,color.blue,__ALEFT)
			end
			
			screen.print(938,y,list_tmp[i].id,1.2,color.white,0x0,__ARIGHT)
			y += 45
		end

		---- Draw Scroll Bar
		local ybar,hbar = 55, (limit*45)
		draw.fillrect(950,ybar-2,8,hbar,color.shine)
		--if scroll.maxim >= limit then
			local pos_height = math.max(hbar/scroll.maxim, limit)
			--Bar Scroll
			draw.fillrect(950, ybar-2 + ((hbar-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))
		--end

		screen.print(480, 490, descript,1,color.white,color.blue,__ACENTER)

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(45,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.released.cancel then break end

		--Exit
		if buttons.start then
			exit_bye_bye()
		end

		vol_mp3()

		if scroll.maxim > 0 then
			if buttons.left or buttons.right then xscroll = 10 end

			if buttons.up or buttons.analogly < -60 then
				if scroll:up() then xscroll = 10 end
			end
			if buttons.down or buttons.analogly > 60 then
				if scroll:down() then xscroll = 10 end
			end

			if buttons.accept then
				return list_tmp[scroll.sel].id
			end
		end

	end

end


function VitaNearest()

	--if os.dialog(LANGUAGE["MENU_PSVITA_INSTALL_NEAREST_Q"], LANGUAGE["MENU_PSVITA_INSTALL_NEAREST"], __DIALOG_MODE_OK_CANCEL) == true then
	local _section = search_gameid()
	if _section then
		
		--os.message(_section)

		if _section == "ALL" then
			--Buscar todos los gameids de este plugin y borrarlos de tai
			local ids = tai.findALL("VitaNearestNeighbour.suprx")
			if ids then
				for i=1,#ids do
					--os.message()
					tai.del(ids[i].section,"VitaNearestNeighbour.suprx")
				end
			end

			files.copy(path_plugins.."VitaNearestNeighbour.suprx", path_tai)
			tai.put("ALL",  "ur0:tai/VitaNearestNeighbour.suprx")
			ReloadConfig = true

			os.message("VitaNearestNeighbour.suprx\n\nALL\n\n"..LANGUAGE["STRING_INSTALLED"])
				
		else
			files.copy(path_plugins.."VitaNearestNeighbour.suprx", path_tai)
			tai.del("ALL", "VitaNearestNeighbour.suprx")
			tai.put(_section,  "ur0:tai/VitaNearestNeighbour.suprx")
			ReloadConfig = true

			os.message("VitaNearestNeighbour.suprx".."\n\n".._section.."\n\n"..LANGUAGE["STRING_INSTALLED"])
		end

	end

end