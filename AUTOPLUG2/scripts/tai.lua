--[[ 
	Tai Config Library.
	Search, Insert, Delete your plugins fast!.
	
	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Designed By DevDavisNunez (https://twitter.com/DevDavisNunez).
	Date: 12/07/2017 at 06:40 pm
	
	Modificada por gdljjrod 2019
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

tai = {
	{},--ux0 index 1
	{},--ur0 index 2
}

tai_ux0_path = "ux0:tai/config.txt"
tai_ur0_path = "ur0:tai/config.txt"

--Internal
function load_config(path, index)
	print("Loading taiCfg from %s\n",path)

	tai[index].raw = {}
	for line in io.lines(path) do
		if line:byte(#line) == 13 then line = line:sub(1,#line-1) end --Remove CR == 13
		table.insert(tai[index].raw, line)
	end
	--tai[index].path = path

	tai.parse(index)

	--tai.debug(index)
		--tai.repair(index)
	--tai.debug(index)

end

--[[
	NIL tai.load()
	When executing this function, the txt is loaded completely to ram, 
	thus allowing the native parse, quickly and easily and work in a virtual way its contents.
]]
function tai.load()

	tai[1].exist,tai[2].exist = false,false
	tai[1].path,tai[2].path = tai_ux0_path,tai_ur0_path

	if files.exists(tai_ux0_path) and not files.info(tai_ux0_path).directory then
		load_config(tai_ux0_path,1)
		tai[1].exist = true
	end

	
	if files.exists(tai_ur0_path) and not files.info(tai_ur0_path).directory then
		load_config(tai_ur0_path,2)
		tai[2].exist = true
	end

end

--[[
	NIL tai.parse(index)
	When executing this function, the txt is parsed to native arrays and can work by index direct.
]]
function tai.parse(index)

	if tai[index].raw then

		tai[index].gameid = {}

		local id_sect = nil
		for i=1, #tai[index].raw do

			local line = tai[index].raw[i]

			if #line > 1 then
				if line:find("*",1,true) then -- Secction Found.
					id_sect = line:sub(2)
					--os.message("id_sect\n"..id_sect)
					--print("Section found %s\n", id_sect)
					if not tai[index].gameid[id_sect] then tai[index].gameid[id_sect] = { line = {}, prx = {}, section = id_sect } end
					table.insert(tai[index].gameid[id_sect].line, i)
					continue
				end

				if id_sect and not line:find("#",1,true) then -- Is a path and not a comment.
					--print("[%s]: %s\n", id_sect, line:lower())
					if not line:find("henkaku.suprx",1,true) then
						--os.message("line\n"..line:lower())
						table.insert(tai[index].gameid[id_sect].prx, { path=line:lower(), line=i })
					end
				end
			end

		end
	end

end

--[[
	NIL tai.repair()
	When executing this function, a massive scan is done in the txt, of scattered GAMEID�s,
	concentrating these into a single one, and preserving the first id found in the txt, or if section is void, delete.
	Useful to repair previous errors in the use of the same.
]]
function tai.repair(index)

	if tai[index].raw and tai[index].gameid then
		for k,v in pairs(tai[index].gameid) do

			local len = #v.line
			if len > 1 then

				tai.delete_sect(index, v) -- Remove all sections of id...

				-- Reinsert in first pos! :D
				table.insert(tai[index].raw,v.line[1], "*"..k)
				for a=1, #v.prx do
					table.insert(tai[index].raw,v.line[1]+a, v.prx[a].path)
				end
				tai.parse(index)

				return tai.repair(index) -- recursive! :D

			elseif #v.prx < 1 then -- No have any plug?, remove!!!!

				local id = tai[index].gameid[k].section
				--os.message(section)
				if id != "KERNEL" and id != "main" and id != "ALL" and id != "NPXS10015" and id != "NPXS10016" then
					--os.message(section)
					tai.delete_sect(index, v) -- Remove all sections of id...
					tai.parse(index)

					return tai.repair(index) -- recursive! :D
				end
			end

		end--for
	end

end

function tai.delete_sect(index, v) -- Internal use...

	local len = #v.line

	for a=len, 1, -1 do
		for b=#v.prx, 1, -1 do
			if v.prx[b].line > v.line[a] and not v.prx[b].rv then
				--print("Line: %d - Removed: %s\n", v.prx[b].line,
				table.remove(tai[index].raw, v.prx[b].line)--)
				v.prx[b].rv = true
			end
		end

		--print("Line: %d - Removed: %s\n",v.line[a],
		table.remove(tai[index].raw, v.line[a])--)

	end

end

--[[
	NUMBER tai.find(index, id, path)
	Search a filename in the list of plugin of the id.
	return nil in case of error, index in success.
]]
function tai.find(index, id, path)

	if not tai[index].gameid[id] then return nil end

	local fname = files.nopath(path)--name or ""
	fname = fname:lower()

	for i=1, #tai[index].gameid[id].prx do
		local x1,x2 = string.find(tai[index].gameid[id].prx[i].path:lower(), fname, 1, true)
		if x1 then
			return i
		end
	end

	return nil
end

--[[
	NUMBER tai.put(index, id, path)
	Add a filename in the list of plugin of the id, if the id no exists, then create a id or if exists id and path then nothing do!
	return false in case of error, true in success.
]]
function tai.put(index, id, path, pos)

	local idx = tai.find(index, id, path)

	if idx then -- Nothing to do... :O ?
		--tai[index].gameid[id].prx[idx].path =

	elseif tai[index].gameid[id] then -- Exists the id then have any prx!

		idx = #tai[index].gameid[id].prx

		if pos then
			table.insert(tai[index].raw, tai[index].gameid[id].line[1]+pos, path)
		else
			if idx > 0 then
				table.insert(tai[index].raw, tai[index].gameid[id].prx[idx].line+1, path)
			else
				table.insert(tai[index].raw, tai[index].gameid[id].line[1] + 1, path)
			end
		end

		tai.parse(index) -- Refresh all ids lines etc..
		--tai.debug()
		return true

	else -- New ID new path!
		table.insert(tai[index].raw, "*"..id)
		table.insert(tai[index].raw, path)
		tai.parse(index) -- Refresh all ids lines etc..
		--tai.debug()
		return true
	end

	return false

end

--[[
	NUMBER tai.del(id, path)
	Remove a filename in the list of plugin of the id, if the id no have more prx, its erase!
	return false in case of error, true in success.
]]
function tai.del(index, id, path)

	local idx = tai.find(index, id, path)

	if idx then
		table.remove(tai[index].raw, tai[index].gameid[id].prx[idx].line)

		if #tai[index].gameid[id].prx == 1 and (id != "KERNEL" and id != "main" and id != "ALL" and id != "NPXS10015" and id != "NPXS10016") then -- remove section if not have nothing more prx!
			--os.message("tai.del\n"..#tai[index].gameid[id].prx.."\nid "..id)
			table.remove(tai[index].raw, tai[index].gameid[id].line[1])
		end
		tai.parse(index) -- Refresh all ids lines etc..
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
function tai.sync(index, path)
	if tai[index].raw then
		files.write(path or tai[index].path, table.concat(tai[index].raw, '\n'))
	end
end

function tai.debug(index)
	return nil
	--[[print("### CONFIG.TXT ##\n")
	if tai[index].raw then
		for i=1,#tai[index].raw do
			print("#%03d: %s\n",i,tai[index].raw[i])
		end
	end
	print("##################\n")]]
end

--[[ ## Simple test ##

tai.load(files.fullpath("config.txt",0))
print("Find: %s\n",tostring(tai.find("KERNEL", "ux0:cheDs4vita.skprx")))
print("Put: %s\n",tostring(tai.put("main", "ur0:tai/pngshot.suprx")))
print("Put: %s\n",tostring(tai.put("ONELUA4R0", "ur0:tai/functions.suprx")))
print("Del: %s\n",tostring(tai.del("CNPEZ0002", "ux0:algunamadre.suprx")))
print("Del: %s\n",tostring(tai.del("NPUG80318", "ux0:adrenaline/adrenaline.suprx")))
tai.sync()
buttons.waitforkey()
err()
]]