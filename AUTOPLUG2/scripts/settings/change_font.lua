--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function change_font()

	local fonts = files.listfiles("ux0:data/AUTOPLUGIN2/font/")

	local current_font = nil

	local tb = { { name = LANGUAGE["FONT_DEFAULT"], ext = "pgf" }, { name = LANGUAGE["FONT_DEFAULT_PVF"], ext = "pvf" }, }

	for i=1,#fonts do
		if __FONT:lower() == fonts[i].name:lower() and files.exists("ux0:data/AUTOPLUGIN2/font/"..fonts[i].name) and not current_font then current_font = fonts[i].name end
		if files.exists("ux0:data/AUTOPLUGIN2/font/"..fonts[i].name) and (fonts[i].ext:upper() == "PGF" or fonts[i].ext:upper() == "PVF" or fonts[i].ext:upper() == "TTF") then
			table.insert(tb, fonts[i])
		end
	end

	if not current_font then
		if type_fnt == __FONT_TYPE_PGF then
			current_font = LANGUAGE["FONT_DEFAULT"]
		else
			current_font = LANGUAGE["FONT_DEFAULT_PVF"]
		end
	end

	local maxim,y1 = 8,85
	local scroll = newScroll(tb,maxim)
	local xscroll = 10

	while true do
		buttons.read()

		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_TITLE_FONT"],1.2,color.white,0x0,__ACENTER)

		if scroll.maxim > 0 then

			local y = y1
			for i=scroll.ini,scroll.lim do
				if i == scroll.sel then draw.offsetgradrect(17,y-12,938,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
				screen.print(30,y,tb[i].name,1.2,color.white,0x0)
				y += 45
			end--for

			--Bar Scroll
			local ybar, h = y1-10, (maxim*45)-4
			draw.fillrect(3, ybar-3, 8, h, color.shine)
			local pos_height = math.max(h/scroll.maxim, maxim)
			draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))

			if screen.textwidth(LANGUAGE["MENU_CURRENT_FONT"]..current_font) > 925 then
				xscroll = screen.print(xscroll, 445, LANGUAGE["MENU_CURRENT_FONT"]..current_font, 1, color.white, color.blue, __SLEFT,935)
			else
				screen.print(10, 445,LANGUAGE["MENU_CURRENT_FONT"]..current_font,1,color.white,color.blue,__ALEFT)
			end

		else
			screen.print(480,230, LANGUAGE["FONT_FAILED"], 1, color.white, color.blue, __ACENTER)
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
			if buttons.down or buttons.analogly > 60 then scroll:down() end

			if buttons.accept then

				if scroll.sel == 1 then

					__FONT, type_fnt = "", __FONT_TYPE_PGF
					current_font = LANGUAGE["FONT_DEFAULT"]
					font.setdefault(__FONT_TYPE_PGF)

				elseif scroll.sel == 2 then

					__FONT, type_fnt = "font.pvf", __FONT_TYPE_PVF
					current_font = LANGUAGE["FONT_DEFAULT_PVF"]
					font.setdefault(__FONT_TYPE_PVF)

				else

					fnt = font.load("ux0:data/AUTOPLUGIN2/font/"..tb[scroll.sel].name)

					if fnt then
						type_fnt, __FONT = font.type(fnt), tb[scroll.sel].name
						current_font = __FONT
						font.setdefault(fnt)
					else
						__FONT, type_fnt = "", __FONT_TYPE_PGF
						current_font = LANGUAGE["FONT_DEFAULT"]
						font.setdefault()
					end
				end

				if back then back:blit(0,0) end
					message_wait(LANGUAGE["FONT_RELOAD"])
				os.delay(1500)

				write_config()

			end

		end

		if buttons.released.cancel then	break end
	
	end--while

	
end
