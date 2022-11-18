--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function change_lang()

	local langs = {
		{ file = "JAPANESE",		name = LANGUAGE["JAPANESE"],		},
		{ file = "ENGLISH_US",		name = LANGUAGE["ENGLISH_US"],		},
		{ file = "FRENCH",			name = LANGUAGE["FRENCH"],			},
		{ file = "SPANISH",			name = LANGUAGE["SPANISH"],			},
		{ file = "GERMAN",			name = LANGUAGE["GERMAN"],			},
		{ file = "ITALIAN",			name = LANGUAGE["ITALIAN"],			},
		{ file = "DUTCH",			name = LANGUAGE["DUTCH"],			},
		{ file = "PORTUGUESE",		name = LANGUAGE["PORTUGUESE"],		},
		{ file = "RUSSIAN",			name = LANGUAGE["RUSSIAN"],			},
		{ file = "KOREAN",			name = LANGUAGE["KOREAN"],			},
		{ file = "CHINESE_T",		name = LANGUAGE["CHINESE_T"],		},
		{ file = "CHINESE_S",		name = LANGUAGE["CHINESE_S"],		},
		{ file = "FINNISH",			name = LANGUAGE["FINNISH"],			},
		{ file = "SWEDISH",			name = LANGUAGE["SWEDISH"],			},
		{ file = "DANISH",			name = LANGUAGE["DANISH"],			},
		{ file = "NORWEGIAN",		name = LANGUAGE["NORWEGIAN"],		},
		{ file = "POLISH",			name = LANGUAGE["POLISH"],			},
		{ file = "PORTUGUESE_BR",	name = LANGUAGE["PORTUGUESE_BR"],	},
		{ file = "ENGLISH_GB",		name = LANGUAGE["ENGLISH_GB"],		},
		{ file = "TURKISH",			name = LANGUAGE["TURKISH"],			},
	}

	local current_lang = nil
	local tb = {}
			if #langs > 1 then table.sort(langs ,function (a,b) return string.lower(a.file)<string.lower(b.file) end) end
	for i=1,#langs do
		if __LANG == langs[i].file and files.exists("lang/"..langs[i].file..".lua") and not current_lang then current_lang = langs[i].name end
		if files.exists("lang/"..langs[i].file..".lua") then
			table.insert(tb, langs[i])
		end
	end
	if not current_lang then current_lang = "ENGLISH_US" end

	local maxim,y1 = 7,80
	local scroll = newScroll(tb,maxim)
	local xscroll,xcroll2 = 10,10

	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end
		if math.minmax(tonumber(os.date("%d%m")),2012,2512) == tonumber(os.date("%d%m")) then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
        screen.print(480,20,LANGUAGE["MENU_TITLE_LANGUAGE"],1.2,color.white,0x0,__ACENTER)

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

			if screen.textwidth(LANGUAGE["TRANSLATE_CURRENT_TITLE"]..tostring(os.language())) > 925 then
				xcroll2 = screen.print(xcroll2, 445, LANGUAGE["TRANSLATE_CURRENT_TITLE"]..tostring(os.language()), 1, color.white, color.blue, __SLEFT,935)
			else
				screen.print(10, 445,LANGUAGE["TRANSLATE_CURRENT_TITLE"]..tostring(os.language()),1,color.white,color.blue,__ALEFT)
			end
			if screen.textwidth(LANGUAGE["TRANSLATE_CURRENT_AUTOPLUGIN"]..current_lang) > 925 then
				xscroll = screen.print(xscroll, 475, LANGUAGE["TRANSLATE_CURRENT_AUTOPLUGIN"]..current_lang, 1, color.white, color.blue, __SLEFT,935)
			else
				screen.print(10, 475,LANGUAGE["TRANSLATE_CURRENT_AUTOPLUGIN"]..current_lang,1,color.white,color.blue,__ALEFT)
			end

		else
			screen.print(480,230, LANGUAGE["LANGUAGE_FAILED"], 1, color.white, color.blue, __ACENTER)
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

				official, user, s = nil,nil, nil

				-- Official Translations
				official,s = loadfile("lang/"..tb[scroll.sel].file..".lua")
				if not official then
					if s then
						os.dialog("\n"..s.."\n\n\n"..LANGUAGE["SYSTEM_ERROR_REPO"].."\n\n"..LANGUAGE["SYSTEM_ERROR_FIX"], LANGUAGE["SYSTEM_ERROR"])
					else
						os.dialog(LANGUAGE["ERROR_LOADING_FILE"].."\n\n".."lang/"..tb[scroll.sel].file..".lua".."\n\n\n"..LANGUAGE["SYSTEM_ERROR_REPO"], LANGUAGE["SYSTEM_ERROR"])
					end
					break
				end

				-- User Translations
				if files.exists("ux0:data/AUTOPLUGIN2/lang/"..tb[scroll.sel].file..".lua") then
					user,s = loadfile("ux0:data/AUTOPLUGIN2/lang/"..tb[scroll.sel].file..".lua")
					if not user then
						if s then
							os.dialog("\n"..s.."\n\n\n"..LANGUAGE["SYSTEM_ERROR_REPO"].."\n\n"..LANGUAGE["SYSTEM_ERROR_FIX"], LANGUAGE["SYSTEM_ERROR"])
						else
							os.dialog(LANGUAGE["ERROR_LOADING_FILE"].."\n\n".."ux0:data/AUTOPLUGIN2/lang/"..tb[scroll.sel].file..".lua".."\n\n\n"..LANGUAGE["SYSTEM_ERROR_REPO"], LANGUAGE["SYSTEM_ERROR"])
						end
						break
					end
				end

				if official then
					LANGUAGE = {}

					dofile("lang/ENGLISH_US.lua")
					update_language(ENGLISH_US)

					official()
					load_language(tb[scroll.sel].file, true)
				end

				if user then
					user()
					load_language(tb[scroll.sel].file)
				end

				dofile("plugins/plugins.lua")
				if #plugins > 0 then table.sort(plugins, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end

				if __UPDATE == 0 then _update = LANGUAGE["NO"] else	_update = LANGUAGE["YES"] end
				if __AUTO == 0 then _autotai = LANGUAGE["NO"] else _autotai = LANGUAGE["YES"] end

				__LANG, fnt, type_fnt = tb[scroll.sel].file, nil, __FONT_TYPE_PGF
				__FONT = ini.read(__PATH_INI,"FONT","font","")

				if __FONT != "" then
					if __FONT == "font.pvf" then
						font.setdefault(__FONT_TYPE_PVF)
						type_fnt = __FONT_TYPE_PVF
					else
						fnt = font.load("ux0:data/AUTOPLUGIN2/font/"..__FONT)
						if fnt then
							font.setdefault(fnt)
							type_fnt = font.type(fnt)
						end
					end
				end

				if __LANG == "CHINESE_T" or __LANG == "CHINESE_S" or __LANG == "TURKISH" then
					if not files.exists("ux0:data/AUTOPLUGIN2/font/font.pgf") then
						if back2 then back2:blit(0,0) end
							message_wait(LANGUAGE["CHINESE_FONT_DOWNLOAD"])
						os.delay(500)
						__file = "font.pgf"
							http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/font/font.pgf", APP_REPO, APP_PROJECT), "ux0:data/AUTOPLUGIN2/font/font.pgf")
						__file = ""
					end
					if not fnt then
						fnt, __FONT = font.load("ux0:data/AUTOPLUGIN2/font/font.pgf"), "font.pgf"
						if fnt then
							font.setdefault(fnt)
							type_fnt = font.type(fnt)
						end
					end
				end

				os.delay(150)
				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["LANGUAGE_RELOAD"])
				os.delay(1500)

				--Pendiente update para plugins PSP
				dofile("plugins/plugins_psp.lua")

				write_config()
				dofile("menu.lua")
				break
			end

		end

		if buttons.released.cancel then	break end
	
	end--while

	
end
