--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

dofile("git/shared.lua")
PLUGINS_PORT = channel.new("PLUGINS_PORT")
cont_global = atomic.new(0)
PLUGINS_PORT:push(cont_global)
THIDS = thread.new("scripts/thread/thread_plugins.lua")

if files.exists("ux0:/app/ONEUPDATE") then
	game.delete("ONEUPDATE") -- Exists delete update app
end

--Activamos Paleta de Colores Precargados
color.loadpalette()

--Creamos nuestra carpeta principal de Trabajo
files.mkdir("ux0:data/AUTOPLUGIN2/")
__PATH_INI    = "ux0:data/AUTOPLUGIN2/config.ini"

--Show splash
--splash.zoom("imgs/splash.png")

--Imagen de Fondo
back = image.load("imgs/back.png")
back2 = image.load("imgs/back2.png")

--Sprites para Botones
buttonskey = image.load("imgs/buttons.png",20,20)
buttonskey2 = image.load("imgs/buttons2.png",20,20)
buttonskey3 = image.load("imgs/buttons3.png",35,25)
dotg = image.load("imgs/dot_green.png")
doty = image.load("imgs/dot_yellow.png")

__LANG = ini.read(__PATH_INI,"LANGUAGE","lang","")
if __LANG == "" then __LANG = os.language() end
dofile("scripts/language.lua")

-- Loading font
files.mkdir("ux0:data/AUTOPLUGIN2/font/")
fnt = nil
__FONT = ini.read(__PATH_INI,"FONT","font","")
if __FONT != "" then
	fnt = font.load("ux0:data/AUTOPLUGIN2/font/"..__FONT)
end

if __LANG == "CHINESE_T" or __LANG == "CHINESE_S" or __LANG == "TURKISH" then
	if not files.exists("ux0:data/AUTOPLUGIN2/font/font.pgf") then
		message_wait(LANGUAGE["CHINESE_FONT_DOWNLOAD"])
		http.getfile(string.format("https://raw.githubusercontent.com/%s/%s/master/font/font.pgf", APP_REPO, APP_PROJECT), "ux0:data/AUTOPLUGIN2/font/font.pgf")
	end
	if not fnt then fnt, __FONT = font.load("ux0:data/AUTOPLUGIN2/font/font.pgf"), "font.pgf" end
end
if fnt then font.setdefault(fnt) end

if os.access() == 0 then
	if back then back:blit(0,0) end
	screen.flip()
	os.message(LANGUAGE["STRING_UNSAFE_MODE"])
	os.exit()
end

dofile("scripts/commons.lua")
dofile("scripts/scroll.lua")

__UPDATE = tonumber(ini.read(__PATH_INI,"UPDATE","update","1"))
_update = LANGUAGE["NO"]
if __UPDATE == 1 then
	_update = LANGUAGE["YES"]
	dofile("git/updater.lua")
end
write_config()

--Copy defect for config.txt
dofile("scripts/tai.lua")
if not files.exists(tai_ux0_path) and not files.exists(tai_ur0_path) then files.copy("resources/config/config.txt", "ur0:tai/") end

--Init load configs
tai.load()

tai.sync(__UX0, "ux0:tai/config.txt")
tai.sync(__UR0, "ur0:tai/config.txt")

--Backups
tai.sync(__UX0, "ux0:tai/config_backup.txt")
tai.sync(__UR0, "ur0:tai/config_backup.txt")


if back then back:blit(0,0) end
	message_wait(LANGUAGE["STRING_BACKUP_CONFIGS"])
os.delay(1500)

dofile("scripts/psvita/menu_psvita.lua")
dofile("scripts/psp/menu_psp.lua")
dofile("scripts/extras/menu_extras.lua")
dofile("scripts/settings/menu_settings.lua")

--Main Cycle
dofile("menu.lua")
