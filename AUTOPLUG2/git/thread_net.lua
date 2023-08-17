dofile("git/shared.lua")

UPDATE_PORT = channel.new("UPDATE_PORT")
yes_update = UPDATE_PORT:pop()
__VERSION = 0
local info = http.get("http://devdavisnunez.x10.mx/wikihb/api/v1/auto_update.php?id=152&v="..APP_VERSION);
if info then
    info /= "|"
	local version = info[1]
	if version and tonumber(version) then
		version = tonumber(version)
		local major = (version >> 0x18) & 0xFF;
		local minor = (version >> 0x10) & 0xFF;
		if version > APP_VERSION then
			__VERSION = 1
			UPDATE_PORT:push({version, tostring(info[2] or "")})
		end
		if version == APP_VERSION then
			__VERSION = 2
		--2.00 = 33554432
		elseif version >= 33554432 then
			__VERSION = 3
		end
	end
end
yes_update:set(__VERSION)
yes_update:lost()