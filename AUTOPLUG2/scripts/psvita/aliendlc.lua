AlienShooter = false

--Ckecking game Alien Shooter
AlienTB = {
	{ id = "PCSE00445", region = "North America" },
	{ id = "PCSB00561", region = "Europe" },
}

gamesAlien = {}
for i=1,#AlienTB do
	if game.exists(AlienTB[i].id) then
		AlienShooter = true
		table.insert(gamesAlien,AlienTB[i])
	end
end

function AlienShooter_DLC_Unlocker()

	if not AlienShooter then os.dialog(LANGUAGE["NO_ALIENSHOOTER_GAMES"], LANGUAGE["MENU_PSVITA_AL_DLC_UNLOCKER"]) return end

	local AlienShooter_ID = "ALIENDLC.png"

	local patches = {
		{ res = LANGUAGE["MENU_PSVITA_AL_DLC_UNLOCKER"],  desc = LANGUAGE["INSTALLP_DESC_ALIENDLC"], path = "alienhook.suprx" },
	}

	for i=1,#patches do
		for j=1,#plugins do
			if patches[i].desc == plugins[j].desc then
				patches[i].res = plugins[j].name
			end
		end
	end

	local scroll,selector,xscroll = newScroll(patches,#patches),1,10
	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)--
		screen.print(480,20,LANGUAGE["MENU_PSVITA_AL_DLC_UNLOCKER"],1.0,color.white,color.blue,__ACENTER)

		draw.fillrect(0,64,960,322,color.shine:a(25))

		--Games
		local xRoot = 200
		local w = (955-xRoot)/#gamesAlien
		for i=1, #gamesAlien do
			if selector == i then
				draw.fillrect(xRoot,63,w,42, color.green:a(90))
			end
			screen.print(xRoot+(w/2), 75, gamesAlien[selector].id, 1, color.white, color.blue, __ACENTER)
			draw.fillrect(750,435,200,42, color.shine:a(25))
			screen.print(940,445,gamesAlien[selector].region,1,color.white,color.blue, __ARIGHT)
			xRoot += w
		end

		local y = 155
		for i=scroll.ini, scroll.lim do

			if i == scroll.sel then	draw.offsetgradrect(3,y-10,952,38,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			idx = tai.find(gamesAlien[selector].id,patches[i].path)
			if idx != nil then
				if files.exists(tai.gameid[ gamesAlien[selector].id ].prx[idx].path) then
					if dotg then dotg:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.green:a(205)) end
				else
					if doty then doty:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.yellow:a(205)) end
				end
			end

			screen.print(25,y, patches[i].res)
			y+=45
		end

		if patches[scroll.sel].desc then
			if screen.textwidth(patches[scroll.sel].desc) > 925 then
				xscroll = screen.print(xscroll, 400, patches[scroll.sel].desc,1,color.green,0x0,__SLEFT,935)
			else
				screen.print(480, 400, patches[scroll.sel].desc,1,color.green,0x0,__ACENTER)
			end
		end

		if #gamesAlien > 1 then
			if buttonskey2 then buttonskey2:blitsprite(5,448,2) end
			if buttonskey2 then buttonskey2:blitsprite(35,448,3) end
			screen.print(70,450, LANGUAGE["INSTALL_P4G_HD_CHANGE"],1,color.white,color.black,__ALEFT)
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

			--L/R
			if buttons.released.l or buttons.released.r then
				if buttons.released.l then selector -= 1 else selector += 1 end
				if selector > #gamesAlien then selector = 1
				elseif selector < 1 then selector = #gamesAlien end
			end

			if buttons.accept then

				local vbuff = screen.buffertoimage()

				local onNetGetFileOld = onNetGetFile
				onNetGetFile = nil

				local img = image.load(screenshots..AlienShooter_ID)
				if not img then
					if http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/screenshots/%s", APP_REPO, APP_PROJECT, AlienShooter_ID), screenshots..AlienShooter_ID).success then
						img = image.load(screenshots..AlienShooter_ID)
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

				Patch_AlienShooter_install(gamesAlien[selector],patches[scroll.sel])
			end

		end

	end

end

function Patch_AlienShooter_install(game,res)

	--Copy plugin to tai folder
	files.copy(path_plugins..res.path, path_tai)
	tai.put(game.id, path_tai..res.path)
	ReloadConfig = true

	if back2 then back2:blit(0,0) end
		message_wait(res.res.."\n\n"..LANGUAGE["STRING_INSTALLED"])
	os.delay(850)

end
