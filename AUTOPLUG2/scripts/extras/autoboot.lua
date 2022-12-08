--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

files.mkdir("ux0:data/AutoBoot/")
Autoboot_path = "ux0:data/AutoBoot/boot.cfg"

function autoboot()

	if not files.exists(Autoboot_path) then
		files.new(Autoboot_path)
	end

	local current = ""

	for line in io.lines(Autoboot_path) do
		current = line
		break
	end
	--os.message(tostring(current))

	local list_tmp = game.list(__GAME_LIST_APP)
	if list_tmp then
		table.sort(list_tmp, function (a,b) return string.lower(a.title)<string.lower(b.title) end)
	end

	local limit = 9
	local scroll = newScroll(list_tmp,limit)
	local xscroll = 13

	buttons.interval(10,6)
	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.black:a(100))
		draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_AUTOBOOT_TITLE"],1.2,color.white,0x0,__ACENTER)

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

		--Current
		screen.print(13,475,LANGUAGE["CURRENT"]..current,1,color.green, 0x0, __ALEFT)

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
				local fp = io.open(Autoboot_path, "w+")
				if fp then
					fp:write(list_tmp[scroll.sel].id)
					fp:close()
					change = true
					os.dialog("\n"..Autoboot_path.."\n\n"..LANGUAGE["GAMEID"]..list_tmp[scroll.sel].id, LANGUAGE["MENU_AUTOBOOT_TITLE"])
					current = list_tmp[scroll.sel].id
				end
			end
		end

	end
end
