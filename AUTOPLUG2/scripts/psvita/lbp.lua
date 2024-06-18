LBP = false

--Ckecking game LBP_IDs
LBP_IDs = {
	{ id = "PCSA22018", region = "US Cartridge" },
	{ id = "PCSA00017", region = "US Digital" },
	{ id = "PCSA00549", region = "US Digital (MVS edition)" },
	{ id = "PCSF00021", region = "EU Cartridge" },
	{ id = "PCSF00516", region = "EU Cartridge (MVS edition)" },
	{ id = "PCSA22106", region = "Canada Cartridge" },
	{ id = "PCSD00006", region = "Asia Cartridge" },
	{ id = "VCAS32010", region = "Asia Cartridge" },
	{ id = "PCSC00013", region = "JP Digital" },
	{ id = "VCJS10006", region = "JP Cartridge" },
	{ id = "VCKS62003", region = "Korea Cartridge" },

}

gamesLBP = {}
for i=1,#LBP_IDs do
	if game.exists(LBP_IDs[i].id) then
		LBP = true
		local tmp = game.details(LBP_IDs[i].id)
		LBP_IDs[i].version = tmp.version or "0.00" 
		table.insert(gamesLBP,LBP_IDs[i])
	end
end

function LBP_server()

	if not LBP then os.dialog(LANGUAGE["NO_LBP_GAMES"], LANGUAGE["INSTALL_LBP_TITLE"]) return end
	
	if ( __VERSION != "3.60" and __VERSION != "3.65") then os.message(LANGUAGE["INSTALLP_CWARNING_360_365"]) return
	end

	local LBP_table = {}
	for i=1,#plugins do

		if plugins[i].path == "Allefresher_vita.suprx" then
			LBP_table.id = plugins[i].id
			LBP_table.title = plugins[i].name.." "..plugins[i].v
			LBP_table.path = plugins[i].path
		end

	end

	local scroll,xscroll = newScroll(gamesLBP,7),10
	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		screen.print(480,20,LBP_table.title,1.0,color.white,color.blue,__ACENTER)
		draw.fillrect(0,64,960,322,color.shine:a(25))

		local y = 90
		for i=scroll.ini, scroll.lim do

			if i == scroll.sel then draw.offsetgradrect(5,y-12,943,40,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			idx = tai.find(gamesLBP[i].id,LBP_table.path)
			if idx != nil then
				if files.exists(tai.gameid[ gamesLBP[i].id ].prx[idx].path) then
					if dotg then dotg:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.green:a(205)) end
				else
					if doty then doty:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.yellow:a(205)) end
				end
			end

			screen.print(25,y, gamesLBP[i].id)
			y+=45
		end

		draw.fillrect(690,435,270,42, color.shine:a(25))
		screen.print(950,445,gamesLBP[scroll.sel].region,1,color.white,color.blue, __ARIGHT)

		if screen.textwidth(LANGUAGE["LBP_ALLEFRESHER_DESC"]) > 925 then
			xscroll = screen.print(xscroll, 400, LANGUAGE["LBP_ALLEFRESHER_DESC"],1,color.green,0x0,__SLEFT,935)
		else
			screen.print(480, 400, LANGUAGE["LBP_ALLEFRESHER_DESC"],1,color.green,0x0,__ACENTER)
		end

		if buttonskey then buttonskey:blitsprite(10, 483, saccept) end
		screen.print(40, 485, LANGUAGE["MENU_INSTALL_INFO"], 1, color.white, color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,518,scancel) end
		screen.print(40,522,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.cancel then break end

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
				local vbuff = screen.buffertoimage()

				local onNetGetFileOld = onNetGetFile
				onNetGetFile = nil

				local img = image.load(screenshots..LBP_table.id)
				if not img then
					if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/screenshots/%s", APP_REPO, APP_PROJECT, LBP_table.id), screenshots..LBP_table.id).success then
						img = image.load(screenshots..LBP_table.id)
					end
				end

				onNetGetFile = onNetGetFileOld				
				if img then
					if vbuff then vbuff:blit(0,0) elseif back2 then back2:blit(0,0) end
					img:scale(85)
					img:center()
					img:blit(480,272)
					screen.flip()
					--buttons.waitforkey()
					os.delay(1200)
				end
				img,vbuff = nil,nil
				if gamesLBP[scroll.sel].version != "01.22" then os.message(LANGUAGE["INSTALLING_LBP_VERSION"]) else
					Patch_LBP_install(gamesLBP[scroll.sel],LBP_table)
				end
			end

		end

	end

end

function Patch_LBP_install(game,t)

	--Copy plugin to tai folder
	files.copy(path_plugins..t.path, path_tai)

	tai.put(game.id, path_tai..t.path)
	ReloadConfig = true

	if back2 then back2:blit(0,0) end
		message_wait(LANGUAGE["INSTALLING_LBP_PATCH"])
	os.delay(850)

end
