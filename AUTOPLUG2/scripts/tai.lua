--[[ 
	Tai Config Library.
	Search, Insert, Delete your plugins fast!.
	
	Licensed by Creative Commons Attribution-NoDerivs 2.0 Generic
	https://creativecommons.org/licenses/by-nd/2.0/
	
	Designed By DevDavisNunez (https://twitter.com/DevDavisNunez).
	v1.0 - 12/07/2017 at 06:40 pm
	- Initial Library
	v1.1 - 14/03/2019 at 05:05 pm
	- Added option to blend config's.
	v1.2 - 15/04/2020 at 08:50 pm
	- Fix the 'repair' method to contain a single plugin equal per GAMEID.
	v1.3 - 17/04/2020 at 01:02 pm
	- Fix the 'parse' method to contain a single plugin equal per GAMEID.
	- Added default config txt load.
	- Added Always Safe Plugins Henkaku.
	v1.4 - 18/04/2020 at 07:08 am
	- Improved multiple file mixing.
	v1.5 - 28/10/2020 at 09:24 pm
	- tai.check(id) add by gdl(Iteración de tai.raw en busqueda de "!AKRK00005"
]]

-- Write a file.
function files.write(path, data, mode)
	local fp = io.open(path, mode or "w+")
	if fp == nil then return end
	fp:write(data)
	fp:flush()
	fp:close()
end

-- Read a file.
function files.read(path, mode)
	local fp = io.open(path, mode or "r")
	if not fp then return nil end
	local data = fp:read("*a")
	fp:close()
	return data
end

__TAI_PATH_UR0 = "ur0:tai/config.txt"
__TAI_PATH_UX0 = "ux0:tai/config.txt"
__TAI_PATH_UMA0 = "uma0:tai/config.txt"
__TAI_PATH_IMC0 = "imc0:tai/config.txt"

tai = {} -- Lib TAI

tai.mix_path = {__TAI_PATH_UX0, __TAI_PATH_UMA0, __TAI_PATH_IMC0}


--[[
	NIL tai.load()
	When executing this function, the txt is loaded completely to ram, 
	thus allowing the native parse, quickly and easily and work in a virtual way its contents.
]]
function tai.load(path, mix_path)
	tai.raw = {}
	tai.path = path or __TAI_PATH_UR0
	if files.exists(tai.path) and not files.info(tai.path).directory then
		--print(string.format("Loading taiCfg from %s", tai.path))
		for line in io.lines(tai.path) do
			if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13
			table.insert(tai.raw, line)
		end
		tai.parse()
		--tai.debug()
		tai.repair()
		tai.debug()
	else
		tai.raw = {
		"# This file is used as an alternative if ux0:tai/config.txt is not found.",
		"# For users plugins, you must refresh taiHEN from HENkaku Settings for",
		"# changes to take place.",
		"# For kernel plugins, you must reboot for changes to take place.",
		"*KERNEL",
		"# henkaku.skprx is hard-coded to load and is not listed here",
		"*main",
		"# main is a special titleid for SceShell",
		"ur0:tai/henkaku.suprx",
		"*NPXS10015",
		"# this is for modifying the version string",
		"ur0:tai/henkaku.suprx",
		"*NPXS10016",
		"# this is for modifying the version string in settings widget",
		"ur0:tai/henkaku.suprx",
		}
		tai.parse()
		tai.sync()
		--print("Error loading taiCfg from %s, use default\n", tai.path)
	end
	local other_txt = mix_path or tai.mix_path
	local ismix = false;
	for i=1, #other_txt do
		if files.exists(other_txt[i]) and not files.info(other_txt[i]).directory then -- checar en otras particiones como uma0, imc0?
			local ux_raw = {}
			for line in io.lines(other_txt[i]) do
				if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13
				table.insert(ux_raw, line)
			end
			tai.parse(ux_raw, true)
			tai.debug()
			files.delete(other_txt[i]) -- Delete 4 ever :D
			ismix = true
		end
	end
	if ismix then -- for test disable!!!
		tai.sync()
	end
end


--[[
	NIL tai.parse()
	When executing this function, the txt is parsed to native arrays and can work by index direct.
]]
function tai.parse(data, blend)
	local raw = data or tai.raw
	if raw then
		local game_id = {}
		local nr = {}
		local id_sect = nil
		local len = #raw
		for i=1, len do
			local line = raw[i]
			if not line then continue end
			if #line == 0 and raw[i+1] and (raw[i+1]:find(":",1,true) or #raw[i+1] == 0) then
				table.remove(raw, i) -- We remove empty lines if continue plugs in the same section only.
				--print("remove ln empty "..i.."\n")
			end
			if line:find("*",1,true) then -- Secction Found.
				id_sect = line:sub(2)
				if id_sect:lower() == "kernel" then raw[i] = "*KERNEL"
				elseif id_sect:lower() == "main" then raw[i] = "*main"
				elseif id_sect:lower() == "all" then raw[i] = "*ALL" end
				line = raw[i]
				id_sect = line:sub(2)
				--print(string.format("Section found %s", id_sect))
				-- TO-DO: add support to section´s with ! is a section will be no load by taihen, but how to handle with tai?
				if not game_id[id_sect] then game_id[id_sect] = { line = {}, prx = {}, section = id_sect }; nr[id_sect] = {} end
				table.insert(game_id[id_sect].line, i)
				continue
			end

			if id_sect and not line:find("#",1,true) and line:find(":",1,true) then -- Is a path and not a comment. TODO  afect delete_sect method.
				if not nr[id_sect][line:lower()] then
					nr[id_sect][line:lower()] = true;
					--print(string.format("[%s]: %s", id_sect, line:lower()))
					table.insert(game_id[id_sect].prx, { path=line:lower(), line=i, is_sys = line:find("henkaku.suprx",1,true)}) -- skip in your app if the subtable have is_sys, example if list[i].is_sys
					if blend then tai.put(id_sect, line:lower()) end
				else
					--print(string.format("Repeated [%s]: %s", id_sect, line:lower()))
					--print(i)
					table.remove(raw, i)
					--len -= 1
				end
			end

		end
		if not blend then tai.gameid = game_id end
	end
end

--[[
	NIL tai.repair()
	When executing this function, a massive scan is done in the txt, of scattered GAMEID?s,
	concentrating these into a single one, and preserving the first id found in the txt, or if section is void, delete.
	Useful to repair previous errors in the use of the same.
]]
function tai.repair()

	if tai.raw and tai.gameid then
		for k,v in pairs(tai.gameid) do

			local len = #v.line
			if len > 1 then

				tai.delete_sect(v) -- Remove all sections of id...
				local h = {}
				-- Reinsert in first pos! :D
				table.insert(tai.raw,v.line[1], "*"..k)
				local s = 1;
				for a=1, #v.prx do
					if not h[v.prx[a].path] then
						h[v.prx[a].path] = true
						table.insert(tai.raw, v.line[1]+s, v.prx[a].path)
						s += 1
					--else
						--table.remove(tai.raw, v.prx[a].line)
					end
				end
				tai.parse()

				return tai.repair() -- recursive! :D

			elseif #v.prx < 1 then -- No have any plug?, remove!!!!
				local id = tai.gameid[k].section
				--print(string.format("Delete no plug: %s | hold: %s\n", tostring(section), tostring(id == "KERNEL" and id == "main" and id == "ALL" and id == "NPXS10015" and id == "NPXS10016")))
				if id[1] != "!" and id != "KERNEL" and id != "main" and id != "ALL" and id != "NPXS10015" and id != "NPXS10016" then
					tai.delete_sect(v) -- Remove all sections of id...
					tai.parse()
					return tai.repair() -- recursive! :D
				end
			end

		end--for
	end

end

function tai.delete_sect(v) -- Internal use...

	local len = #v.line

	for a=len, 1, -1 do
		for b=#v.prx, 1, -1 do
			if v.prx[b].line > v.line[a] and not v.prx[b].rv then
				--print(string.format("ILine: %d - Removed: %s\n", v.prx[b].line, tai.raw[v.prx[b].line]))
				table.remove(tai.raw, v.prx[b].line)--)
				v.prx[b].rv = true
			end
		end

		--print(string.format("OLine: %d - Removed: %s\n",v.line[a], tai.raw[v.line[a]]))
		table.remove(tai.raw, v.line[a])--)

	end

end

--[[
	NUMBER tai.find(id, path)
	Search a filename in the list of plugin of the id.
	return nil in case of error, index in success.
]]
function tai.find(id, path)

	if not tai.gameid[id] then return nil end

	local fname = files.nopath(path)--name or ""
	fname = fname:lower()

	for i=1, #tai.gameid[id].prx do
		local x1,x2 = string.find(tai.gameid[id].prx[i].path:lower(), fname, 1, true)
		if x1 then
			return i
		end
	end

	return nil
end

--[[
	NUMBER tai.put(id, path)
	Add a filename in the list of plugin of the id, if the id no exists, then create a id or if exists id and path then nothing do!
	return false in case of error, true in success.
]]
function tai.put(id, path, pos)

	local idx = tai.find(id, path)

	if idx then -- Nothing to do... :O ?
		--tai.gameid[id].prx[idx].path =

	elseif tai.gameid[id] then -- Exists the id then have any prx!

		idx = #tai.gameid[id].prx

		if pos then
			table.insert(tai.raw, tai.gameid[id].line[1]+pos, path)
		else
			if idx > 0 then
				table.insert(tai.raw, tai.gameid[id].prx[idx].line+1, path)
			else
				table.insert(tai.raw, tai.gameid[id].line[1] + 1, path)
			end
		end

		tai.parse() -- Refresh all ids lines etc..
		--tai.debug()
		return true

	else -- New ID new path!
		table.insert(tai.raw, "*"..id)
		table.insert(tai.raw, path)
		tai.parse() -- Refresh all ids lines etc..
		--tai.debug()
		return true
	end

	return false

end

function tai.check(id)
	local len = #tai.raw
	for i=1, len do
		local line = tai.raw[i]
		if line:find("!AKRK00005", 1, true) then
			return true
		end
	end
	return false

end

function tai.putBeforeSection(section, id, path, pos)
	if tai.gameid[id] then
		tai.delete_sect(tai.gameid[id])
		tai.parse()
	end
	if tai.gameid[section] then
		--search
		local len = #tai.raw
		for i=1, len do
			local line = tai.raw[i]
			if line:sub(2) == section then
				table.insert(tai.raw, i, path)
				table.insert(tai.raw, i, id)
				tai.parse() -- Refresh all ids lines etc..
				--tai.debug()
				return true
			end
		end
		return false
	else
		return tai.put(id, path, pos)
	end
end

--[[
	NUMBER tai.del(id, path)
	Remove a filename in the list of plugin of the id, if the id no have more prx, its erase!
	return false in case of error, true in success.
]]
function tai.del(id, path)

	local idx = tai.find(id, path)

	if idx then
		table.remove(tai.raw, tai.gameid[id].prx[idx].line)
		if #tai.gameid[id].prx == 1 and (id != "KERNEL" and id != "main" and id != "ALL" and id != "NPXS10015" and id != "NPXS10016") then -- remove section if not have nothing more prx!
			table.remove(tai.raw, tai.gameid[id].line[1])
		end
		tai.parse() -- Refresh all ids lines etc..
		--tai.debug()
		return true
	end

	return false
end

--[[
	NIL tai.sync([path])
	Can send a path to sync or use the default.
	Synchronize all the changes made so far with the library.
]]
function tai.sync(path)
	if tai.raw then
		--TO-DO: hacer un backup y posteriormente escribir el nuevo?.
		-- SAFE PUT CHECK SYS PRX
		tai.put("main", "ur0:tai/henkaku.suprx", 1)
		tai.put("NPXS10015", "ur0:tai/henkaku.suprx", 1)
		tai.put("NPXS10016", "ur0:tai/henkaku.suprx", 1)
		tai.del("KERNEL", "ur0:tai/henkaku.suprx")
		
		local force_path = {
		  { path = "ur0:tai/ds34vita.skprx", section = "KERNEL" },
		  { path = "ur0:tai/ds4touch.skprx", section = "KERNEL" },
		  { path = "ur0:tai/reVita.skprx", section = "KERNEL" },
		  { path = "ur0:tai/udcd_uvc_lcd_off.skprx", section = "KERNEL" },
		  { path = "ur0:tai/udcd_uvc_oled_off.skprx", section = "KERNEL" },
		  { path = "ur0:tai/udcd_uvc.skprx", section = "KERNEL" },
		  { path = "ur0:tai/custom_warning.suprx", section = "main" },
		  { path = "ur0:tai/custom_boot_splash.skprx", section = "KERNEL" },
		  { path = "ur0:tai/repatch_4.skprx", section = "KERNEL" },
		  { path = "ur0:tai/repatch.skprx", section = "KERNEL" },
		  { path = "ur0:tai/0syscall6.skprx", section = "KERNEL" },
		  { path = "ur0:tai/reF00D.skprx", section = "KERNEL" },
		  { path = "ur0:tai/nonpdrm_un.skprx", section = "KERNEL" },
		  { path = "ur0:tai/nonpdrm.skprx", section = "KERNEL" },
		  { path = "ur0:tai/gamesd.skprx", section = "KERNEL" },
		  { path = "ur0:tai/storagemgr.skprx", section = "KERNEL" },
		  { path = "ur0:tai/EmergencyMount.skprx", section = "KERNEL" },
		}
		local force_state = {}
		for i=1, #force_path do
			force_state[i] = tai.del(force_path[i].section, force_path[i].path)
		end
		for i=1, #force_path do
			if force_state[i] then
				tai.put(force_path[i].section, force_path[i].path, 1)
			end
		end
		files.write(path or tai.path, table.concat(tai.raw, '\n'))
	end
end

function tai.debug()
	return nil
	--[[print("### CONFIG.TXT ###")
	if tai.raw then
		for i=1,#tai.raw do
			print(string.format("#%03d: %s",i,tai.raw[i]))
		end
	end
	print("##################\n")]]
end

-- ## Simple test ##
--tai.load()
--[[print("Find: %s\n",tostring(tai.find("KERNEL", "ux0:cheDs4vita.skprx")))
print("Put: %s\n",tostring(tai.put("main", "ur0:tai/pngshot.suprx")))
print("Put: %s\n",tostring(tai.put("ONELUA4R0", "ur0:tai/functions.suprx")))
print("Del: %s\n",tostring(tai.del("CNPEZ0002", "ux0:algunamadre.suprx")))
print("Del: %s\n",tostring(tai.del("NPUG80318", "ux0:adrenaline/adrenaline.suprx")))
tai.sync()]]
--buttons.waitforkey()
--err()