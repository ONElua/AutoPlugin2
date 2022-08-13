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

	--Remove lines for psm_disclaimer_yes_i_read_the_readme
	if line_find_add_psm > 0 then
		table.remove(tb_config,line_find_add_psm)
	end

	--Remove lines for install_psp_as_pbp
	if options[1].status == false then table.remove(tb_config,line_find_install_as_pbp) end

	--Insert new lines
	if line_find_install_location == 0 then table.insert(tb_config, "install_psp_psx_location "..options[2].status) end
	if line_find_install_as_pbp == 0 and options[1].status == true then	table.insert(tb_config, "install_psp_as_pbp 1") end

	--Update config.txt
	local fp = io.open(path, "w+")
	for s,t in pairs(tb_config) do
		fp:write(string.format('%s\n', tostring(t)))
	end
	fp:close()

end

function read_config(file, tb_config)

	files.mkdir(files.nofile(file))
	if not files.exists(file) then files.new(file)	end

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

function downloadtsv_callback()

	local path_configtxt = "ux0:pkgj/"
	if files.exists("ur0:pkgj/config.txt") then path_configtxt = "ur0:pkgj/" end

	local tsv = {

		{ url = "https://nopaystation.com/tsv/PSV_GAMES.tsv",  name = "titles_psvgames.tsv", sname = LANGUAGE["MENU_EXTRAS_PSV_GAMES_TSV"],
			info = files.info(path_configtxt.."titles_psvgames.tsv"), },
		{ url = "https://nopaystation.com/tsv/PSV_DLCS.tsv",   name = "titles_psvdlcs.tsv", sname = LANGUAGE["MENU_EXTRAS_PSV_DLC_TSV"],
			info = files.info(path_configtxt.."titles_psvdlcs.tsv"),   },
		{ url = "https://nopaystation.com/tsv/PSV_DEMOS.tsv",  name = "titles_psvdemos.tsv", sname = LANGUAGE["MENU_EXTRAS_PSV_DEMOS_TSV"],
			info = files.info(path_configtxt.."titles_psvdemos.tsv"),  },
		{ url = "https://nopaystation.com/tsv/PSV_THEMES.tsv", name = "titles_psvthemes.tsv", sname = LANGUAGE["MENU_EXTRAS_PSV_THEMES_TSV"],
			info = files.info(path_configtxt.."titles_psvthemes.tsv"), },
		{ url = "https://nopaystation.com/tsv/PSM_GAMES.tsv",  name = "titles_psmgames.tsv", sname = LANGUAGE["MENU_EXTRAS_PSM_GAMES_TSV"],
			info = files.info(path_configtxt.."titles_psmgames.tsv"),  },
		{ url = "https://nopaystation.com/tsv/PSX_GAMES.tsv",  name = "titles_psxgames.tsv", sname = LANGUAGE["MENU_EXTRAS_PSX_GAMES_TSV"],
			info = files.info(path_configtxt.."titles_psxgames.tsv"),  },
		{ url = "https://nopaystation.com/tsv/PSP_GAMES.tsv",  name = "titles_pspgames.tsv", sname = LANGUAGE["MENU_EXTRAS_PSP_GAMES_TSV"],
			info = files.info(path_configtxt.."titles_pspgames.tsv"),  },
		{ url = "https://nopaystation.com/tsv/PSP_DLCS.tsv",   name = "titles_pspdlcs.tsv", sname = LANGUAGE["MENU_EXTRAS_PSP_DLC_TSV"],
			info = files.info(path_configtxt.."titles_pspdlcs.tsv"),   },
	}

	files.delete(path_configtxt.."dbtmp.tsv")

	local scroll,xscroll = newScroll(tsv,8),10
	while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_EXTRAS_DOWNLOAD_TSV"],1.2,color.white,0x0,__ACENTER)

		draw.fillrect(0,64,960,322,color.shine:a(25))

		local y = 83
		for i=scroll.ini, scroll.lim do
			if i == scroll.sel then draw.offsetgradrect(3,y-10,952,38,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end
			screen.print(25,y, tsv[i].sname,1.1,color.white,color.black, __ALEFT)
			if tsv[i].info then
				screen.print(940,y, tsv[i].info.mtime,1.2,color.white,color.black, __ARIGHT)
			end
			y += 38
		end

		screen.print(480, 408, path_configtxt..tsv[scroll.sel].name,1.2,color.green,0x0,__ACENTER)

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

				if vbuff then vbuff:blit(0,0) elseif back2 then back2:blit(0,0) end
					message_wait()
				os.delay(500)

				__file = tsv[scroll.sel].name

				buttons.homepopup(0)
				local res = http.download(tsv[scroll.sel].url, path_configtxt.."dbtmp.tsv")
				if res and res.success and files.exists(path_configtxt.."dbtmp.tsv") then
					files.delete(path_configtxt..tsv[scroll.sel].name)
					files.rename(path_configtxt.."dbtmp.tsv", tsv[scroll.sel].name)
					tsv[scroll.sel].info = files.info(path_configtxt..tsv[scroll.sel].name)
				else
					os.dialog(tsv[scroll.sel].name.."\n\n"..LANGUAGE["INSTALLP_NO_VPK"])
				end

				files.delete("ux0:pkgj/dbtmp.tsv")
				__file = ""

			end

		end

	end

	__file = ""
	files.delete(path_configtxt.."dbtmp.tsv")
end

function config_pkgj()

	--Clean
	line_find_install_as_pbp, line_find_install_location, line_find_add_psm = 0,0,0
	mount_install = "ux0:"
	local tb_config = {}

	local path_configtxt = "ux0:pkgj/config.txt"
	if files.exists("ur0:pkgj/config.txt") then path_configtxt = "ur0:pkgj/config.txt"
	elseif files.exists("ux0:pkgj/config.txt") then path_configtxt = "ux0:pkgj/config.txt"
	elseif files.exists("ur0:pkgi/config.txt") then path_configtxt = "ur0:pkgi/config.txt"
	elseif files.exists("ux0:pkgi/config.txt") then path_configtxt = "ux0:pkgi/config.txt" end

	local check_config = read_config(path_configtxt, tb_config)
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
	}

	--UPdate Status
	if line_find_install_as_pbp > 0 then menuext[1].status = true end
	if pmount == 0 then menuext[2].pmount = 1 else menuext[2].pmount = pmount end
	menuext[2].status = PMounts[menuext[2].pmount]

	local scroll,xscroll = newScroll(menuext,#menuext),5
	while true do
		buttons.read()
		if change then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end

		draw.offsetgradrect(0,0,960,55,color.blue:a(85),color.blue:a(85),0x0,0x0,20)
		screen.print(480,20,LANGUAGE["MENU_EXTRAS_PKGJ_TITLE"],1.2,color.white,0x0,__ACENTER)

		draw.fillrect(0,64,960,322,color.shine:a(25))

		local y = 110
		for i=scroll.ini, scroll.lim do

			if i == scroll.sel then draw.offsetgradrect(3,y-10,952,38,color.shine:a(75),color.shine:a(135),0x0,0x0,21) end

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

		screen.print(480, 360, path_configtxt,1.2,color.green,0x0,__ACENTER)

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

			if buttons.triangle then

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
