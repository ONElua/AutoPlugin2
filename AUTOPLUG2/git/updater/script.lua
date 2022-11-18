--[[
	Updater Of App.
	Designed by DevDavisNunez to ONElua projects.. :D
	TODO:
	Maybe, extract in APP, and only installdir in this..
]]

buttons.homepopup(0)
color.loadpalette()
update = image.load("update.png")

if update then update:blit(0,0) end
screen.flip()

args = os.arg()
if args:len() == 0 then
	os.message("UPDATER_ERROR")
	os.exit()
end

args /= "&"
if #args != 5 then
	os.message("UPDATER_ERROR")
	os.exit()
end

dofile("language.lua")

function onAppInstall(step, size_argv, written, file, totalsize, totalwritten)

	if update then update:blit(0,0) end
	draw.fillrect(0,0,960,30, color.green:a(100))

	if step == 1 then												-- Only msg of state
		screen.print(10,10,LANGUAGE["UPDATER_SEARCH_UNSAFE_VPK"])
	elseif step == 2 then											-- Warning Vpk confirmation!
		return 10 -- Ok
	elseif step == 3 then											-- Unpack
		screen.print(10,10,LANGUAGE["UPDATER_UNPACK_VPK"])
		screen.print(10,35,LANGUAGE["UPDATER_FILE"]..tostring(file))
		screen.print(10,55,LANGUAGE["UPDATER_PERCENT"]..math.floor((written*100)/size_argv).." %")

		l = (totalwritten*940)/totalsize
		screen.print(3+l,495,math.floor((totalwritten*100)/totalsize).."%",0.8,0xFFFFFFFF,0x0,__ACENTER)
			draw.fillrect(10,524,l,6,color.new(0,255,0))
				draw.circle(10+l,526,6,color.new(0,255,0),30)

	elseif step == 4 then											-- Promote or install
		screen.print(10,10,LANGUAGE["UPDATER_INSTALLING"])
	end
	screen.flip()
end


snd = sound.load("ux0:data/AUTOPLUGIN2/bg/bg.mp3",1) or sound.load("ux0:data/AUTOPLUGIN2/bg/bg.ogg")
if snd then
	sound.loop(snd)
	snd:play(1)
end

game.install(args[3])--Path to vpk
files.delete(args[3])--delete vpk

buttons.homepopup(1)

game.launch(args[2])--Launch titleID
