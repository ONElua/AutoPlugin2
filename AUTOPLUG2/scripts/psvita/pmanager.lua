--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

function searchPlugByPath(p, sect, path)
	--print(string.format("SPP [%s]: %s|%d", (sect or "NOTHING"), (path or "unkpath"), (idx or 999)))
	if not p or not sect or not p[sect] then return nil end
	for i=1, #p[sect] do
		if path:lower() == files.nopath(p[sect][i].path:lower()) then
			return i;
		end
	end
	return nil
end

function pluginsmanager()

	local sections = {"KERNEL", "main", "ALL"}
	local plugs = {}
	local bridge_s = {}
	local bridge_n = {}
	local tb_cop = {}
	update_translations(plugins, tb_cop)

	for k = #tb_cop,1,-1 do
		if tb_cop[k].REMOVE then
			table.remove(tb_cop,k)
		end
	end

	table.insert(tb_cop, { name = "Kuio by Rinnegatamante", path = "kuio.skprx", section = "KERNEL", desc = LANGUAGE["INSTALLP_DESC_KUIO"] } )
	table.insert(tb_cop, { name = "Ds3 (Plugin required for MiniVitaTV)", path = "ds3.skprx", section = "KERNEL", path2 = "minivitatv.skprx", section2 = "KERNEL", version = "0001", desc = LANGUAGE["INSTALLP_DESC_MINIVITATV_DS3"] })
	table.insert(tb_cop, { name = "iTLS-Enso by SKGleba", path = "itls.skprx", section = "KERNEL", desc = LANGUAGE["INSTALLP_DESC_ITLSENSO"] })
	table.insert(tb_cop, { name = "Yamt-Vita by SKGleba", path = "yamt.suprx", section = "NPXS10015", desc = LANGUAGE["INSTALLP_DESC_YAMT"] })
	table.insert(tb_cop, { name = "StorageMgr CelesteBlue", path = "storagemgr.skprx", section = "KERNEL", desc = LANGUAGE["INSTALLP_DESC_SD2VITA"] })
	table.insert(tb_cop, { name = "Sysident by cuevavirus", path = "sysident.skprx", section = "KERNEL", desc = LANGUAGE["INSTALLP_DESC_SYSIDENT"] })
	table.insert(tb_cop, { name = "Ds4touch by MERLev", path = "ds4touch.skprx", section = "KERNEL", path2 = "ds4touch.suprx", section2 = "ALL", desc = LANGUAGE["INSTALLP_DESC_DS4TOUCH"] })
	table.insert(tb_cop, { name = "Daemon for Vitadb-Downloader", path = "vdb_daemon.suprx", section = "main", desc = LANGUAGE["INSTALLP_DESC_DAEMON"] })
	table.insert(tb_cop, { name = "Vita-Nearest-Neighbour by MuxaJlbl4", path = "VitaNearestNeighbour.suprx", desc = LANGUAGE["INSTALLP_DESC_VITANEARESTN"] })


	for k,v in pairs(tai.gameid) do
		if k:lower() != "kernel" and k:lower() != "main" and k:lower() != "all" then
			table.insert(sections, k)
		end
		plugs[k] = {}
		update_translations(tai.gameid[k].prx, plugs[k])
	end

	for y=1, #sections do
		if not plugs[sections[y]] then plugs[sections[y]] = {} end -- empty
		if not bridge_s[sections[y]] then bridge_s[sections[y]] = {} end -- empty
		for x=1, #plugs[sections[y]] do

			plugs[sections[y]][x].section = sections[y]
			plugs[sections[y]][x].exists = files.exists(plugs[sections[y]][x].path)
			plugs[sections[y]][x].file = files.nopath(plugs[sections[y]][x].path:lower())
			bridge_s[sections[y]][plugs[sections[y]][x].file] = {s = sections[y], i = x}
			--os.message(plugs[sections[y]][x].file)

			if not bridge_n[plugs[sections[y]][x].file] then bridge_n[plugs[sections[y]][x].file] = {c = 1} end

			bridge_n[plugs[sections[y]][x].file].c += 1
			bridge_n[plugs[sections[y]][x].file][sections[y]] = x
			--print(string.format("A [%s]: %s|%d", plugs[sections[y]][x].file, sections[y], x))
			for k=1, #tb_cop do
				--os.message("File: "..plugs[sections[y]][x].file.."\n"..tb_cop[k].path:lower())
				local f = plugs[sections[y]][x].file
				local p = tb_cop[k]
				if f == p.path:lower()
					or (p.path2 and f == p.path2:lower())
					or (p.path3 and f == p.path3:lower()) then
					plugs[sections[y]][x].bridge = p
					plugs[sections[y]][x].desc = p.desc
					plugs[sections[y]][x].crc = p.crc
					--os.message("Bridge: "..plugs[sections[y]][x].bridge.name)
					break;
				end
			end
		end
	end

	local maxv = 8
	local xscr1 = 10
	local yi = 70
	local over = 1;
	local scroll = newScroll(plugs[sections[over]], maxv);

	while true do
		buttons.read()
		if change or ReloadConfig then buttons.homepopup(0) else buttons.homepopup(1) end

		if back2 then back2:blit(0,0) end
		if snow then stars.render() end
		wave:blit(0.7,50)

		draw.fillrect(0,0,960,55,color.shine:a(15))
		--draw.offsetgradrect(0,0,960,55,color.black:a(85),color.black:a(135),0x0,0x0,20)
		screen.print(480,18,LANGUAGE["UNINSTALLP_TITLE"],1.0,color.white,color.blue, __ACENTER)

		draw.fillrect(870,0,90,40, color.green:a(90))
		screen.print(900, 12, "ur0:", 1, color.white, color.blue, __ALEFT)

		screen.print(13, 20, " ("..scroll.maxim..")".."  "..string.format("*%s", tostring(sections[over])), 1, color.yellow, 0x0)
		
		if scroll.maxim > 0 then
			local y = yi
			for i = scroll.ini, scroll.lim do
				if i == scroll.sel then
					draw.offsetgradrect(0, y-10, 940, 35, color.shine:a(75), color.shine:a(135), 0x0, 0x0, 21)

					if plugs[sections[over]][i].is_sys then
						screen.print(480, 405, LANGUAGE["UNINSTALLP_SYSTEM_PLUGIN"], 1.0, color.yellow, 0x0, __ACENTER)
					end

					if plugs[sections[over]][i].desc then
						if screen.textwidth(plugs[sections[over]][i].desc) > 925 then
							xscr1 = screen.print(xscr1, 405, plugs[sections[over]][i].desc, 1, color.green, 0x0, __SLEFT, 935)
						else
							screen.print(480, 405, plugs[sections[over]][i].desc, 1.0, color.green, 0x0, __ACENTER)
						end
					end

					if not plugs[sections[over]][i].exists then
						screen.print(480, 440, LANGUAGE["MISSING_PLUGIN"], 1.0, color.yellow, 0x0, __ACENTER)
					end

				end
				if plugs[sections[over]][i].is_sys then ccolor = color.yellow
				elseif not plugs[sections[over]][i].exists then ccolor = color.orange 
				else ccolor = color.white 
				end
				screen.print(20,y, plugs[sections[over]][i].path, 1, ccolor, 0x0)
				y += 40
			end
		else
			screen.print(20, yi, LANGUAGE["UNINSTALLP_NO_PLUGINS"] )
		end

		-- Draw Scroll Bar
		local ybar,hbar = yi-10, (maxv*40)-4
		if scroll.maxim >= maxv then
			draw.fillrect(950,ybar-2,8,hbar,color.shine)
			local pos_height = math.max(hbar/scroll.maxim, maxv)
			--Bar Scroll
			draw.fillrect(950, ybar-2 + ((hbar-pos_height)/(scroll.maxim-1))*(scroll.sel-1), 8, pos_height, color.new(0,255,0))
		end

		if buttonskey2 then buttonskey2:blitsprite(5,498,0) end
		if buttonskey2 then buttonskey2:blitsprite(35,498,1) end
		screen.print(70,500,LANGUAGE["UNINSTALLP_LEFTRIGHT_SECTION"],1,color.white,color.black,__ALEFT)

		screen.print(950, 435, "("..over.."/"..#sections..")",1,color.yellow, 0x0,__ARIGHT)

		--if buttonskey2 then buttonskey:blitsprite(5,498,2) end
		--screen.print(30,500, "Add new plugin",1,color.white,color.black,__ALEFT)

		if buttonskey then buttonskey:blitsprite(5,523,scancel) end
		screen.print(35,525,LANGUAGE["STRING_BACK"],1,color.white,color.black, __ALEFT)
		
		if buttonskey3 then buttonskey3:blitsprite(920,518,1) end
		screen.print(915,522,LANGUAGE["STRING_CLOSE"],1,color.white,color.blue, __ARIGHT)

		screen.flip()

		if buttons.left or buttons.right then xscr1 = 10 end

		if buttons.released.right then
			over += 1
			if over > #sections then over = 1 end
			scroll = newScroll(plugs[sections[over]], maxv);
		end

		if buttons.released.left then
			over -= 1
			if over < 1 then over = #sections end
			scroll = newScroll(plugs[sections[over]], maxv);
		end
		
		if scroll.maxim > 0 then
			if buttons.up or buttons.analogly < -60 then
				if scroll:up() then xscr1 = 10 end
			end
			if buttons.down or buttons.analogly > 60 then
				if scroll:down() then xscr1 = 10 end
			end
			
			if buttons.accept and not plugs[sections[over]][scroll.sel].is_sys then
				local confirm_msg = plugs[sections[over]][scroll.sel].file
				local confirm_title = LANGUAGE["UNINSTALLP_QUESTION"]
				-- If uninstalling ioplus, show dependents right away
				if plugs[sections[over]][scroll.sel].file:lower() == "ioplus.skprx" then
					local deps = {}
					for i=1, #tb_cop do
						local p = tb_cop[i]
						if (p.path2 and p.path2:lower() == "ioplus.skprx") or (p.path3 and p.path3:lower() == "ioplus.skprx") then
							if bridge_n[p.path:lower()] and bridge_n[p.path:lower()][p.section] then
								table.insert(deps, p.path)
							end
						end
					end
					if #deps > 0 then
						confirm_msg = LANGUAGE["UNINSTALLP_QUESTION_NEED"].."\n"..table.concat(deps, "\n").."\n"..LANGUAGE["UNINSTALLP_PLUGINS_NEED"]
						confirm_title = LANGUAGE["MENU_PSVITA_UNINSTALL_PLUGINS_DESC"]
					end
				end
				if os.dialog(confirm_msg, confirm_title, __DIALOG_MODE_OK_CANCEL) == true then

					-- Special for Yamt
					if plugs[sections[over]][scroll.sel].file == "yamt.suprx" then --Yamt
						change = true
						if files.exists("ur0:tai/boot_config.txt") then
							local cont = {}
							for line in io.lines("ur0:tai/boot_config.txt") do
								if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13
								table.insert(cont, line)
							end
							for i=#cont, 1, -1 do
								if string.find(cont[i]:lower(), "ur0:tai/yamt.skprx", 1, true) or string.find(cont[i]:upper(), "YAMT", 1, true) then
									table.remove(cont,i)
								end
							end
							files.write("ur0:tai/boot_config.txt", table.concat(cont, '\n'))
						end
					end

					-- Special for Sysdent
					if plugs[sections[over]][scroll.sel].file == "sysident.suprx" then
						local idx4 = searchPlugByPath(plugs, "KERNEL", "sysident.skprx")
						if idx4 then
							--os.message("ESPECIAL")
							tai.del("KERNEL", plugs["KERNEL"][idx4].path)
							table.remove(plugs["KERNEL"], idx4)
							bridge_n["sysident.skprx"]["KERNEL"] = nil
							change = true
						end
					elseif plugs[sections[over]][scroll.sel].file == "sysident.skprx" then
						local idx4 = searchPlugByPath(plugs, "NPXS10015", "sysident.suprx")
						if idx4 then
							--os.message("ESPECIAL 2")
							tai.del("NPXS10015", plugs["NPXS10015"][idx4].path)
							table.remove(plugs["NPXS10015"], idx4)
							bridge_n["sysident.suprx"]["NPXS10015"] = nil
							change = true
						end
						local idx5 = searchPlugByPath(plugs, "NPXS10016", "sysident.suprx")
						if idx5 then
							--os.message("ESPECIAL 3")
							tai.del("NPXS10016", plugs["NPXS10016"][idx5].path)
							table.remove(plugs["NPXS10016"], idx5)
							bridge_n["sysident.skprx"]["NPXS10016"] = nil
							change = true
						end
					end
					
					-- Special for VitaNearestNeighbour
					local section1 = sections[over]
					local path1 = files.nopath(plugs[sections[over]][scroll.sel].path:lower())

					local section2 = ""
					local path2 = ""
					local section3 = ""
					local path3 = ""

					if plugs[sections[over]][scroll.sel].file:lower() == "vitanearestneighbour.suprx" then
						local idx3 = searchPlugByPath(plugs, sections[over], "vitanearestneighbour.suprx")
						if idx3 then
							--os.message("ESPECIAL")
							tai.del(sections[over], plugs[sections[over]][idx3].path)
							table.remove(plugs[sections[over]], idx3)
							bridge_n["vitanearestneighbour.suprx"][sections[over]] = nil
							ReloadConfig = true
						end
					else

						if plugs[sections[over]][scroll.sel].bridge then -- Remove second plug of the selected
							section1 = plugs[sections[over]][scroll.sel].bridge.section
							path1 = plugs[sections[over]][scroll.sel].bridge.path:lower()
							--os.message("bridge: "..path1.."\n"..section1)
							if plugs[sections[over]][scroll.sel].bridge.section2 then
								section2 = plugs[sections[over]][scroll.sel].bridge.section2
								path2 = plugs[sections[over]][scroll.sel].bridge.path2:lower()
								--os.message("bridge2: "..path2.."\n"..section2)
								if plugs[sections[over]][scroll.sel].bridge.section3 then
									section3 = plugs[sections[over]][scroll.sel].bridge.section3
								end
								if plugs[sections[over]][scroll.sel].bridge.path3 then
									path3 = plugs[sections[over]][scroll.sel].bridge.path3:lower()
								elseif plugs[sections[over]][scroll.sel].bridge.path2 then
									-- section3 reuses path2 (e.g. turbo storage)
									path3 = plugs[sections[over]][scroll.sel].bridge.path2:lower()
								end
							end
						end

						local idx = searchPlugByPath(plugs, section1, path1);
						if idx then
							--os.message("idx: "..path1.."\n"..section1)
							--Delete plugin
							if path1 then
								--os.message(path1)
								if path1 != "adrenaline_kernel.skprx" then
									--files.delete(plugs[section1][idx].path)
								end
							end
							--print(string.format("E [%s]: %s|%d", path1, section1, (idx or 300)))
							--print(plugs[section1][idx].path)
							tai.del(section1, plugs[section1][idx].path)

						-- Mutual exclusion for NoPspEmuDrm
						if path1 == "nopspemudrm_kern.skprx" then
							tai.del("KERNEL", "NoPspEmuDrm_kern_mod.skprx")
							tai.del("ALL", "NoPspEmuDrm_user_mod.suprx")
						elseif path1 == "nopspemudrm_kern_mod.skprx" then
							tai.del("KERNEL", "NoPspEmuDrm_kern.skprx")
							tai.del("ALL", "NoPspEmuDrm_user.suprx")
						end
						-- restorepsmdev (replaces MakePsmGreatAgain)
						if path1 == "restorepsmdev.suprx" then
							tai.del("PCSI00007", "MakePsmGreatAgain.suprx")
							tai.del("PCSI00009", "MakePsmGreatAgain.suprx")
						end
							table.remove(plugs[section1], idx)
							bridge_n[path1][section1] = nil
						end
					end

					ReloadConfig = true
					change = change or section1:lower() == "main" or section1:lower() == "kernel" or section2:lower() == "main" or section2:lower() == "kernel"

					-- If uninstalling ioplus, also remove dependents (dialog already confirmed)
					if path1 == "ioplus.skprx" then
						for i=1, #tb_cop do
							local p = tb_cop[i]
							if (p.path2 and p.path2:lower() == "ioplus.skprx") or (p.path3 and p.path3:lower() == "ioplus.skprx") then
								if bridge_n[p.path:lower()] and bridge_n[p.path:lower()][p.section] then
									local idx_d = searchPlugByPath(plugs, p.section, p.path:lower())
									if idx_d then
										tai.del(p.section, plugs[p.section][idx_d].path)
										table.remove(plugs[p.section], idx_d)
										bridge_n[p.path:lower()][p.section] = nil
									end
								end
							end
						end
					else
						-- Normal plugin: remove path2 only if it's not ioplus
						if path2 != "" and path2 != "ioplus.skprx" and bridge_n[path2] and bridge_n[path2][section2] then
							local idx3 = searchPlugByPath(plugs, section2, path2)
							if idx3 then
								tai.del(section2, plugs[section2][idx3].path)
								table.remove(plugs[section2], idx3)
								bridge_n[path2][section2] = nil
							end
						end
					end

					--path3 in section3 (e.g. a plugin's Settings page in NPXS10015)
					if section3 != "" and bridge_n[path3] and bridge_n[path3][section3] then
						local idx4 = searchPlugByPath(plugs, section3, path3)
						if idx4 then
							tai.del(section3, plugs[section3][idx4].path)
							table.remove(plugs[section3], idx4)
							bridge_n[path3][section3] = nil
						end
					end

					-- Special: if this plugin used ioplus and no other installed plugin still needs it, remove ioplus
					local used_ioplus = (path2 == "ioplus.skprx") or (path3 == "ioplus.skprx")
					if used_ioplus then
						local others_need = false
						for i=1, #tb_cop do
							local p = tb_cop[i]
							if (p.path2 and p.path2:lower() == "ioplus.skprx") or (p.path3 and p.path3:lower() == "ioplus.skprx") then
								-- still present in config?
								if bridge_n[p.path:lower()] and bridge_n[p.path:lower()][p.section] then
									others_need = true
									break
								end
							end
						end
						if not others_need then
							local idx_io = searchPlugByPath(plugs, "KERNEL", "ioplus.skprx")
							if idx_io then
								tai.del("KERNEL", plugs["KERNEL"][idx_io].path)
								table.remove(plugs["KERNEL"], idx_io)
								if bridge_n["ioplus.skprx"] then bridge_n["ioplus.skprx"]["KERNEL"] = nil end
							end
						end
					end

					scroll = newScroll(plugs[sections[over]], maxv);
					buttons.homepopup(0)
					-- delete prx files?
				end
			end
			
		end
		if buttons.cancel then 
			break
		end

		if buttons.start then
			exit_bye_bye()
		end

		vol_mp3()

		if buttons.triangle then 
			--explorer_plugin()
		end
	end	
end
