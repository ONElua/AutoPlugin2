--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

local line_find_install_as_pbp, line_find_install_location, line_find_add_psm = 0,0,0
local mount_install = "ux0:"

function update_configtxt(path, tb_config, options)

	--Update Line install_psp_psx_location
	if line_find_install_location > 0 then tb_config[line_find_install_location] = "install_psp_psx_location "..options[2].status end

	--Remove lines for install_psp_as_pbp & psm_disclaimer_yes_i_read_the_readme ??
	if line_find_install_as_pbp > line_find_add_psm then
		if options[1].status == false then table.remove(tb_config,line_find_install_as_pbp) end
		if options[3].status == false then table.remove(tb_config,line_find_add_psm) end
	elseif line_find_install_as_pbp < line_find_add_psm then
		if options[3].status == false then table.remove(tb_config,line_find_add_psm) end
		if options[1].status == false then table.remove(tb_config,line_find_install_as_pbp) end
	end

	--Insert new lines
	if line_find_install_location == 0 then table.insert(tb_config, "install_psp_psx_location "..options[2].status) end
	if line_find_install_as_pbp == 0 and options[1].status == true then	table.insert(tb_config, "install_psp_as_pbp 1") end
	if line_find_add_psm == 0 and options[3].status == true then table.insert(tb_config, "psm_disclaimer_yes_i_read_the_readme NoPsmDrm") end

	--Update config.txt
	local fp = io.open(path, "w+")
	for s,t in pairs(tb_config) do
		fp:write(string.format('%s\n', tostring(t)))
	end
	fp:close()

end

function read_config(file, tb_config)

	if not files.exists(file) then
		if files.exists("ux0:pkgi/config.txt") then
			file = "ux0:pkgi/config.txt"
		else
			files.new("ux0:pkgj/config.txt")
			file = "ux0:pkgj/config.txt"
			--return nil
		end
	end

	local cont = 0
	for line in io.lines(file) do
		cont += 1

		if line:find("install_psp_as_pbp", 1, true) then line_find_install_as_pbp = cont end

		if line:find("install_psp_psx_location", 1, true) then
			line_find_install_location = cont

			local text,mount = line:match("(.+) (.+)")
			if text then
				mount_install = mount
			end

		end

		if line:find("psm_disclaimer_yes_i_read_the_readme NoPsmDrm", 1, true) then line_find_add_psm = cont end

		table.insert(tb_config,line)
	end

	return file
end

local psp_eboot_callback = function (obj)
	obj.status = not obj.status
end

local psp_psx_location_callback = function (obj)

	obj.pmount += 1
	if obj.pmount > #PMounts then obj.pmount = 1 end
	if obj.pmount < 0 then obj.pmount = #PMounts end
	
	obj.status = PMounts[obj.pmount]
	
end

local add_psm_callback = function (obj)
	obj.status = not obj.status
end

function config_pkgj()

	--Clean
	line_find_install_as_pbp, line_find_install_location, line_find_add_psm = 0,0,0
	mount_install = "ux0:"
	local tb_config = {}

	local check_config = read_config("ux0:pkgj/config.txt", tb_config)
	if not check_config then
		if vbuff then vbuff:blit(0,0) elseif back2 then back2:blit(0,0) end
		message_wait(LANGUAGE["NO_CONFIG_PKGJ"])
		os.delay(1500)
		return
	end

	local pmount = 0
	for i=1,#PMounts do
		if mount_install == PMounts[i] then pmount = i break end
	end

	local menuext = {
		{ text = LANGUAGE["PKGJ_TITLE_INSTALL_PBP"],	desc = LANGUAGE["PKGJ_DESC_INSTALL_PBP"],	status = false,		funct = psp_eboot_callback },
		{ text = LANGUAGE["PKGJ_TITLE_CHANGE_LOC"],		desc = LANGUAGE["PKGJ_DESC_CHANGE_LOC"],	status = "ux0:",	funct = psp_psx_location_callback },
		{ text = LANGUAGE["PKGJ_TITLE_ADD_PSM"],		desc = LANGUAGE["PKGJ_DESC_ADD_PSM"],		status = false,		funct = add_psm_callback },
	}

	--UPdate Status
	if line_find_install_as_pbp > 0 then menuext[1].status = true end
	if pmount == 0 then menuext[2].pmount = 1 else menuext[2].pmount = pmount end
	menuext[2].status = PMounts[menuext[2].pmount]
	if line_find_add_psm > 0 then	menuext[3].status = true end

	local scroll,xscroll = newScroll(menuext,#menuext),5
	while true do
		buttons.read()
		if back2 then back2:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_EXTRAS_PKGJ_TITLE"],1.2,color.white,0x0,__ACENTER)

		draw.fillrect(0,64,960,322,color.shine:a(25))

		local y = 110
		for i=scroll.ini, scroll.lim do

			if i == scroll.sel then draw.offsetgradrect(3,y-10,952,38,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

			--if i == scroll.sel then draw.fillrect(3,y-4,952,26,color.green:a(105)) end
			screen.print(25,y, menuext[i].text)

			if menuext[i].status == true then
				screen.print(945,y,LANGUAGE["YES"],1,color.white,color.blue, __ARIGHT)
			elseif menuext[i].status == false then
				screen.print(945,y,LANGUAGE["NO"],1,color.white,color.blue, __ARIGHT)
			else
				screen.print(945,y,menuext[i].status,1,color.white,color.blue, __ARIGHT)
			end

			y+=35
		end

		if screen.textwidth(menuext[scroll.sel].desc) > 925 then
			xscroll = screen.print(xscroll, 400, menuext[scroll.sel].desc,1,color.white,color.blue,__SLEFT,935)
		else
			screen.print(480, 400, menuext[scroll.sel].desc,1,color.white,color.blue,__ACENTER)
		end

		if buttonskey then buttonskey:blitsprite(10, 498, __TRIANGLE) end
        screen.print(40, 500, LANGUAGE["PKGJ_UPDATE_CONFIG"], 1, color.white, color.black, __ALEFT)

		if buttonskey then buttonskey:blitsprite(10,523,scancel) end
		screen.print(40,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)

		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		--------------------------	Controls	--------------------------

		if buttons.released.cancel then break end

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

			if buttons.left or buttons.right then xscroll = 10 end

			if buttons.up or buttons.analogly < -60 then
				if scroll:up() then xscroll = 10 end
			end
			if buttons.down or buttons.analogly > 60 then
				if scroll:down() then xscroll = 10 end
			end

			if buttons.triangle then

				--local vbuff = screen.toimage()
				--if vbuff then vbuff:blit(0,0) elseif back2 then back2:blit(0,0) end
				if back2 then back2:blit(0,0) end
					message_wait(LANGUAGE["PKGJ_UPDATING"])
				os.delay(1500)

				update_configtxt(check_config, tb_config, menuext)

			end

			if buttons.left or buttons.right or buttons.accept then
				menuext[scroll.sel].funct(menuext[scroll.sel])
			end

		end

	end

end
