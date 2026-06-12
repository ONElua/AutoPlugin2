--[[

    Licensed by Creative Commons Attribution-ShareAlike 4.0
   http://creativecommons.org/licenses/by-sa/4.0/
   
   Designed By RG & Gdljjrod.
   
]]

dofile("git/shared.lua")

PLUGINS_PORT = channel.new("PLUGINS_PORT")
cont_global = PLUGINS_PORT:pop()
cont_plugins = 0

files.delete("ux0:data/AUTOPLUGIN2/plugins/plugins.lua")
if wlan.isconnected() then
    local res = http.download(string.format("https://raw.githubusercontent.com/%s/%s/master/plugins/plugins.lua", APP_REPO, APP_PROJECT), "ux0:data/AUTOPLUGIN2/plugins/plugins.lua")
	if res.headers and res.headers.status_code == 200 and files.exists("ux0:data/AUTOPLUGIN2/plugins/plugins.lua") then
		LANGUAGE = {}
		dofile("ux0:data/AUTOPLUGIN2/plugins/plugins.lua")
		--Plugins!!!
		dofile("plugins/plugins.lua")
		if #plugins > 0 then table.sort(plugins, function (a,b) return string.lower(a.name)<string.lower(b.name) end) end

		if #Online_Plugins > 0 then
			for i=1,#plugins do

				for j=1,#Online_Plugins do
					if string.upper(plugins[i].KEY) == string.upper(Online_Plugins[j].KEY) then

						if tonumber(plugins[i].version) < tonumber(Online_Plugins[j].version) then
							cont_plugins += 1
						end
					end
				end
			end
		end--Online_Plugins>0

		for i=1,#Online_Plugins do
			local _find = false
			for j=1,#plugins do
				if string.upper(Online_Plugins[i].KEY) == string.upper(plugins[j].KEY) then
					_find = true
					break
				end
			end
			if not _find then
				cont_plugins += 1
			end
		end
	end
end
files.delete("ux0:data/AUTOPLUGIN2/plugins/plugins.lua")
cont_global:set(cont_plugins)
cont_global:lost()
