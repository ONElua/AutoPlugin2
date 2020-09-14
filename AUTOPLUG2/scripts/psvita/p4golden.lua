local P4Golden = false

function P4Golden_HD()

	--Ckecking game P4 Golden
	P4 = {
		{ id = "PCSG00004", region = "Japan" },
		{ id = "PCSG00563", region = "Japan (Reprint)" },
		{ id = "PCSE00120", region = "North America" },
		{ id = "PCSB00245", region = "Europe and Australia" },
		{ id = "PCSH00021", region = "Asia" },

	}

	local gamesP4 = {}
	for i=1,#P4 do
		if game.exists(P4[i].id) then
			P4Golden = true
			table.insert(gamesP4,P4[i])
		end
	end

	if not P4Golden then os.message(LANGUAGE["NO_P4GOLDEN_GAMES"]) return end

	local patchs = {
		{ res = "1920x1080 HD", desc = LANGUAGE["P4G_1920x1080_DESC"], path = "p4goldenhd_1920x1080.suprx" },
		{ res = "1280x720 HD",  desc = LANGUAGE["P4G_1280x720_DESC"], path = "p4goldenhd_1280x720.suprx" },
	}

	for i=1,#patchs do
		for j=1,#plugins do
			if patchs[i].desc == plugins[j].desc then
				patchs[i].res = plugins[j].name
			end
		end
	end

	local scroll,selector,xscroll = newScroll(patchs,#patchs),1,10
	while true do
		buttons.read()
		if back2 then back2:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["INSTALL_P4G_HD_TITLE"],1.2,color.white,0x0,__ACENTER)

		draw.fillrect(0,64,960,322,color.shine:a(25))

		--Games
		local xRoot = 200
		local w = (955-xRoot)/#gamesP4
		for i=1, #gamesP4 do
			if selector == i then
				draw.fillrect(xRoot,63,w,42, color.green:a(90))
			end
			screen.print(xRoot+(w/2), 75, gamesP4[i].id, 1, color.white, color.blue, __ACENTER)
			xRoot += w
		end

		local y = 160
		for i=scroll.ini, scroll.lim do

			if i == scroll.sel then draw.offsetgradrect(3,y-10,952,38,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			idx = tai.find(gamesP4[selector].id,patchs[i].path)
			if idx != nil then
				if files.exists(tai.gameid[ gamesP4[selector].id ].prx[idx].path) then
					if dotg then dotg:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.green:a(205)) end
				else
					if doty then doty:blit(924,y-1) else draw.fillrect(924,y-2,21,21,color.yellow:a(205)) end
				end
			end

			screen.print(25,y, patchs[i].res)
			y+=45
		end

		if patchs[scroll.sel].desc then
			if screen.textwidth(patchs[scroll.sel].desc) > 925 then
				xscroll = screen.print(xscroll, 400, patchs[scroll.sel].desc,1,color.white,color.blue,__SLEFT,935)
			else
				screen.print(480, 400, patchs[scroll.sel].desc,1,color.white,color.blue,__ACENTER)
			end
		end

		if #gamesP4 > 1 then
			if buttonskey2 then buttonskey2:blitsprite(5,448,2) end
			if buttonskey2 then buttonskey2:blitsprite(35,448,3) end
			screen.print(70,450, LANGUAGE["INSTALL_P4G_HD_CHANGE"],1,color.white,color.black,__ALEFT)
		end

		if buttonskey then buttonskey:blitsprite(10, 483, saccept) end
        screen.print(40, 485, LANGUAGE["INSTALL_P4G_HD"], 1, color.white, color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,518,scancel) end
		screen.print(40,522,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.released.cancel then break end

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

			--L/R
			if buttons.released.l or buttons.released.r then
				if buttons.released.l then selector -= 1 else selector += 1 end
				if selector > #gamesP4 then selector = 1
				elseif selector < 1 then selector = #gamesP4 end
			end

			if buttons.accept then
				Patch_P4G_install(gamesP4[selector],patchs[scroll.sel])
			end

		end

	end

end


function Patch_P4G_install(game,res)

	--Copy plugin to tai folder
	files.copy(path_plugins.."p4goldenHD/"..res.path, path_tai)

	tai.del(game.id, "p4goldenhd_1920x1080.suprx")
	tai.del(game.id, "p4goldenhd_1280x720.suprx")

	tai.put(game.id, path_tai..res.path)
	ReloadConfig = true

	if back2 then back2:blit(0,0) end
		message_wait(LANGUAGE["INSTALLING_P4G_HD_PATCH"].."\n\n"..res.res)
	os.delay(850)

end
