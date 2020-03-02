--[[ 
	Autoinstall plugin
	
	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

files.mkdir("ux0:CustomBootsplash/")

function img_fixed(img)
    local w,h = img:getw(), img:geth()

    if w > 960 or h > 544 then
    	return img:copyscale(960, 544)
	end

	local px,py = (960/2)-(w/2), (544/2)-(h/2)
	local sheet = image.new(960, 544, 0x0)
	for y=0,h-1 do
		for x=0,w-1 do
			local c = img:pixel(x,y)
			if c:a() == 0 then c = 0x0 end 
			sheet:pixel(px+x, py+y, c)
		end
	end
	return sheet
end

function img2splashbin(img,flag)

	if img then
		local copy = false
		img:reset()
		if img:getw() != 960 and img:geth() != 544 then
			img = img_fixed(img)
			copy = true
		end

		local data_img = image.data(img)
		if data_img then
			local fp = io.open("ur0:tai/boot_splash.bin","w+")
			if fp then
				fp:write(data_img)
				fp:close()

				if copy then
					files.copy("resources/plugins/custom_boot_splash.skprx", locations[loc].."tai/")
				end

				if flag then
					if back then back:blit(0,0) end
						message_wait(LANGUAGE["INSTALLP_DESC_BOOTSPLASH_DONE"])
					os.delay(1750)
				end

				return 1
			end
		end

	end

	return 0
end

function customimgsplash()

	--Init load configs
	loc = 1
	tai.load()
	local partition = 0
	if tai[__UX0].exist then partition = __UX0
	elseif tai[__UR0].exist then partition,loc = __UR0,2
	end
	path_tai = locations[loc].."tai/"

	local png, custom_boot = files.listfiles("ux0:CustomBootsplash/"), {}

	if png then
		if #png > 0 then
			for i=1,#png do
				if png[i].ext:upper() == "PNG" then
					table.insert(custom_boot, { name = png[i].name, path = png[i].path })
				end
			end
		end
	end
	table.insert(custom_boot, { name = "henkaku.png", path = "imgs/boot_splash.png" })

	table.sort(custom_boot,function(a,b) return string.lower(a.name)<string.lower(b.name) end)

	for i=1,#custom_boot do
		custom_boot[i].img = image.load(custom_boot[i].path)
		if custom_boot[i].img then
			custom_boot[i].img:resize(252,151)
			custom_boot[i].img:setfilter(__IMG_FILTER_LINEAR, __IMG_FILTER_LINEAR)
		end
	end

	local limit = 10
	local scroll = newScroll(custom_boot,limit)

	local install = false
	while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back then back:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["CUSTOMBOOTSPLASH_TITLE"],1.2,color.white,0x0,__ACENTER)

		if scroll.maxim > 0 then

			local y = 80
			for i=scroll.ini, scroll.lim do

				if i == scroll.sel then
					draw.offsetgradrect(15,y-5,680,33,color.shine:a(75),color.shine:a(135),0x0,0x0,21)
					if custom_boot[scroll.sel].img then custom_boot[scroll.sel].img:blit(700,74) end
				end
				screen.print(24,y,custom_boot[i].name,1.0,color.white,color.blue,__ALEFT)
				y+=35
			end

			--Bar Scroll
			local ybar, h = 75, (limit*35)-2
			draw.fillrect(3, ybar-2, 8, h, color.shine)
			--if scroll.maxim >= limit then -- Draw Scroll Bar
				local pos_height = math.max(h/scroll.maxim, limit)
				draw.fillrect(3, ybar-2 + ((h-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))
			--end

			if buttonskey then buttonskey:blitsprite(10,448,saccept) end
			screen.print(45,450, LANGUAGE["CUSTOMBOOTSPLASH_CONVERT"], 1,color.white,color.blue, __ALEFT)

			if buttonskey3 then buttonskey3:blitsprite(5,472,0) end
			screen.print(45,475, LANGUAGE["CUSTOMBOOTSPLASH_IMPORT"], 1,color.white,color.blue, __ALEFT)

		else
			screen.print(480,230, LANGUAGE["CUSTOMBOOTSPLASH_NOPNG_FOUND"], 1, color.white, color.red, __ACENTER)
		end

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(35,525,LANGUAGE["STRING_BACK"],1,color.white,color.blue, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.cancel then
			custom_boot = nil
			collectgarbage("collect")
			os.delay(750)
			--break
			return install
		end

		--Exit
		if buttons.start then
			if change then
				os.message(LANGUAGE["STRING_PSVITA_RESTART"])
				os.delay(250)
				buttons.homepopup(1)
				power.restart()
			end
			os.exit()
		end

		if scroll.maxim > 0 then

			if (buttons.up or buttons.analogly < -60) then scroll:up() end
			if (buttons.down or buttons.analogly > 60) then scroll:down() end

			if buttons.accept then
				if os.message(LANGUAGE["CUSTOMBOOTSPLASH_QUESTION"],1) == 1 then
					files.copy("resources/plugins/custom_boot_splash.skprx",path_tai)
					if img2splashbin(custom_boot[scroll.sel].img,true) == 1 then
						if os.message(LANGUAGE["RESTART_QUESTION"],1) == 1 then
							if back then back:blit(0,0) end
								message_wait(LANGUAGE["STRING_PSVITA_RESTART"])
							os.delay(1500)
							buttons.homepopup(1)
							power.restart()
						else
							custom_boot[scroll.sel].img = image.load(custom_boot[scroll.sel].path)
							if custom_boot[scroll.sel].img then
								custom_boot[scroll.sel].img:resize(252,151)
								custom_boot[scroll.sel].img:setfilter(__IMG_FILTER_LINEAR, __IMG_FILTER_LINEAR)
							end
						end
					else
						os.message(LANGUAGE["INSTALLP_DESC_BOOTSPLASH_FAIL"])
					end
				end
			end

			if buttons.select then
				local tmpimg, typeimg = image.import(back)
				if tmpimg and typeimg == 2 then
					tmpimg:scale(85)
					tmpimg:center()
					tmpimg:blit(480,272)
					screen.flip()
					os.delay(1500)
					if os.message(LANGUAGE["CUSTOMBOOTSPLASH_QUESTION"],1) == 1 then
						files.copy("resources/plugins/custom_boot_splash.skprx",path_tai)
						tmpimg:reset()
						if img2splashbin(tmpimg,true) == 1 then
							if os.message(LANGUAGE["RESTART_QUESTION"],1) == 1 then
								if back then back:blit(0,0) end
									message_wait(LANGUAGE["STRING_PSVITA_RESTART"])
								os.delay(1500)
								buttons.homepopup(1)
								power.restart()
							end
						else
							os.message(LANGUAGE["INSTALLP_DESC_BOOTSPLASH_FAIL"])
						end
					end
				else
					os.message(LANGUAGE["CUSTOMBOOTSPLASH_NOPNG"])
				end
			end--select

		end--maxim>0

	end--while

end
