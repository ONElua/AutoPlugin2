--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

files.mkdir("ur0:/data/quickmenuplus/")

function update_config_quickmenu(tb)
	--Update config.txt
	for i=1,#tb do
		local fp = io.open(tb[i].path, "wb")--w+
		fp:write(tonumber(tb[i].status))
		fp:close()
	end
	change = true
end

function read_config_quickmenu(file)

	if not files.exists(file) then return nil end

	local var_qm = -1
	for line in io.lines(file) do
		var_qm = tonumber(line)
		break
	end
	--os.message(tostring(var_qm))

	return tonumber(var_qm)
end

local push_time_callback = function (obj)

	local quickM = osk.init(LANGUAGE["QUICKMENU_OSK_TITLE_TIME"], obj.status or "350000", 7, __OSK_TYPE_NUMBER, __OSK_MODE_TEXT)
	if quickM then
		obj.status = quickM
		return obj.status
	end

end

local standby_restart_callback = function (obj)
	if obj.status == 0 then obj.status = 1 else obj.status = 0 end
end

local background_style_callback = function (obj)
	if obj.status == 0 then
		obj.status = 1
	elseif obj.status == 1 then
		obj.status = 2
	else
		obj.status = 0
	end
end

function config_quickmenu()

	--Path
	path_config_quickmenu = "ur0:/data/quickmenuplus/"

	local pushtime = read_config_quickmenu(path_config_quickmenu.."pushtime.txt") or "500000"
	local standby = read_config_quickmenu(path_config_quickmenu.."standbyisrestart.txt")
	if standby == nil then
		if hw.model() == "PlayStation TV" then standby = 0 else standby = 1 end
	end
	local bgstyle = read_config_quickmenu(path_config_quickmenu.."bgstyle.txt") or 1


	local menuext = {
		{ text = LANGUAGE["QUICKMENU_MENU_TIME"],				desc = LANGUAGE["QUICKMENU_MENU_TIME_DESC"],			status = tonumber(pushtime),	path = path_config_quickmenu.."pushtime.txt", funct = push_time_callback },
		{ text = LANGUAGE["QUICKMENU_MENU_STANDBYRESTART"],		desc = LANGUAGE["QUICKMENU_MENU_STANDBYRESTART_DESC"],	status = tonumber(standby),		path = path_config_quickmenu.."standbyisrestart.txt", funct = standby_restart_callback },
		{ text = LANGUAGE["QUICKMENU_MENU_BACKGROUNDSTYLE"],	desc = LANGUAGE["QUICKMENU_MENU_BACKGROUNDSTYLE_DESC"],	status = tonumber(bgstyle),		path = path_config_quickmenu.."bgstyle.txt", funct = background_style_callback },
	}


	local scroll,xscroll = newScroll(menuext,#menuext),5
	while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_EXTRAS_QUICKMENU_PLUS"],1.2,color.white,0x0,__ACENTER)

		draw.fillrect(0,64,960,322,color.shine:a(25))

		local y = 110
		for i=scroll.ini, scroll.lim do

			if i == scroll.sel then draw.offsetgradrect(3,y-10,952,38,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			screen.print(25,y, menuext[i].text)
			
			if i == 2 then
				if menuext[i].status == 1 then
					screen.print(945,y,LANGUAGE["QUICKMENU_STANDBYRESTART_ENABLE"],1,color.white,color.blue, __ARIGHT)
				else
					screen.print(945,y,LANGUAGE["QUICKMENU_STANDBYRESTART_DISABLE"],1,color.white,color.blue, __ARIGHT)
				end
			elseif i == 3 then
				if menuext[i].status == 1 then
					screen.print(945,y,LANGUAGE["QUICKMENU_BACKGROUNDSTYLE_TRANSLUCENT"],1,color.white,color.blue, __ARIGHT)
				elseif menuext[i].status == 2 then
					screen.print(945,y,LANGUAGE["QUICKMENU_BACKGROUNDSTYLE_BLACK"],1,color.white,color.blue, __ARIGHT)
				else
					screen.print(945,y,LANGUAGE["QUICKMENU_BACKGROUNDSTYLE_ORIGINAL"],1,color.white,color.blue, __ARIGHT)
				end
			else
				screen.print(945,y,menuext[i].status,1,color.white,color.blue, __ARIGHT)
			end
			
			y+=35
		end

		screen.print(480, 360, menuext[scroll.sel].path,1.2,color.green,0x0,__ACENTER)

		if screen.textwidth(menuext[scroll.sel].desc) > 925 then
			xscroll = screen.print(xscroll, 400, menuext[scroll.sel].desc,1,color.white,color.blue,__SLEFT,935)
		else
			screen.print(480, 400, menuext[scroll.sel].desc,1,color.white,color.blue,__ACENTER)
		end

		if buttonskey then buttonskey:blitsprite(10, 498, __TRIANGLE) end
        screen.print(40, 500, LANGUAGE["QUICKMENU_MENU_UPDATE_CONFIG"], 1, color.white, color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(40,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

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

			if buttons.triangle then

				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["QUICKMENU_MENU_UPDATING"])
				os.delay(1500)

				update_config_quickmenu(menuext)

			end

			if ( (buttons.left or buttons.right) and scroll.sel != 1)  or buttons.accept then
				menuext[scroll.sel].funct(menuext[scroll.sel])
			end

		end

	end

end
