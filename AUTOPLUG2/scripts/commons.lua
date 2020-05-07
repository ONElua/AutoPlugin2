--[[ 
	Autoinstall plugin

	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Dev: TheHeroeGAC
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

__file = ""
function onNetGetFile(size,written,speed)
	if back then back:blit(0,0) end
	draw.fillrect(0,0,960,40, color.green:a(100))

	screen.print(480,12,tostring(__file),1.2,color.white, color.blue:a(135),__ACENTER)

	screen.print(480,470,tostring(files.sizeformat(written or 0)).." / "..tostring(files.sizeformat(size or 0)),1,color.white, color.blue:a(135),__ACENTER)

	l = (written*940)/size
		screen.print(3+l,495,math.floor((written*100)/size).."%",0.8,0xFFFFFFFF,0x0,__ACENTER)
			draw.fillrect(10,524,l,6,color.new(0,255,0))
				draw.circle(10+l,526,6,color.new(0,255,0),30)
	screen.flip()

	return 1
end

function onAppInstall(step, size_argv, written, file, totalsize, totalwritten)

	if back then back:blit(0,0) end
	draw.fillrect(0,0,960,40, color.green:a(100))

    if step == 1 then -- Only msg of state
		screen.print(10,12,LANGUAGE["UPDATER_SEARCH_UNSAFE_VPK"].."   "..tostring(__file))
	elseif step == 2 then											-- Warning Vpk confirmation!
		return 10 -- Ok
	elseif step == 3 then -- Unpack :P

		screen.print(10,12,LANGUAGE["UPDATER_UNPACK_VPK"])
		screen.print(10,55,LANGUAGE["UPDATER_FILE"]..tostring(file))
		screen.print(10,75,LANGUAGE["UPDATER_PERCENT"]..math.floor((written*100)/size_argv).." %")

		l = (totalwritten*940)/totalsize
		screen.print(3+l,495,math.floor((totalwritten*100)/totalsize).."%",0.8,0xFFFFFFFF,0x0,__ACENTER)
			draw.fillrect(10,524,l,6,color.new(0,255,0))
				draw.circle(10+l,526,6,color.new(0,255,0),30)

	elseif step == 4 then											-- Promote or install
		screen.print(10,12,LANGUAGE["UPDATER_INSTALLING"].."   "..tostring(__file))
	end
	screen.flip()
end

function onExtractFiles(size,written,file,totalsize,totalwritten)

	if back then back:blit(0,0) end
	draw.fillrect(0,0,960,40, color.blue:a(100))

	if written != 0 then
		l = (written*940)/size
			screen.print(3+l,495,math.floor((written*100)/size).."%",0.8,0xFFFFFFFF,0x0,__ACENTER)
				draw.fillrect(10,524,l,6,color.new(0,255,0))
					draw.circle(10+l,526,6,color.new(0,255,0),30)
	end

	if totalwritten != 0 then
		screen.print(940,10,LANGUAGE["UPDATER_PERCENT"]..math.floor((totalwritten*100)/totalsize).." %",1.0,color.white, color.blue:a(135),__ARIGHT)
	end
	screen.print(10,10,tostring(file),1.0,color.white, color.blue:a(135))

	message_wait(LANGUAGE["STRING_PLEASE_WAIT"],true)

	screen.flip()
	
	buttons.read()
	return 1
end

function write_config()
	ini.write(__PATH_INI,"UPDATE","update",__UPDATE)
	ini.write(__PATH_INI,"LANGUAGE","lang",__LANG)
	ini.write(__PATH_INI,"FONT","font",__FONT)
end

function draw.offsetgradrect(x,y,sx,sy,c1,c2,c3,c4,offset)
	local sizey = sy/2
		draw.gradrect(x,y,sx,sizey + offset,c1,c2,c3,c4)
			draw.gradrect(x,y + sizey - offset,sx,sizey + offset,c3,c4,c1,c2)
end

function message_wait(message,noflip)
	local mge = (message or LANGUAGE["STRING_PLEASE_WAIT"])
	local titlew = string.format(mge)
	local w,h = screen.textwidth(titlew,1) + 30,70
	local x,y = 480 - (w/2), 272 - (h/2)

	draw.fillrect(x,y,w,h, color.shine)
	draw.rect(x,y,w,h,color.white)
		screen.print(480,y+15, titlew,1,color.white,color.black,__ACENTER)
		
	if not noflip then
		screen.flip()
	end

end

--Variables Universales
path_plugins = "resources/plugins/"
path_tai = "ur0:/tai/"
version = tostring(os.swversion())

--Buttons Assign
__TRIANGLE,__SQUARE = 2,3
saccept,scancel = 1,0
if buttons.assign()==0 then
	saccept,scancel = 0,1
end

PMounts = {}
function check_mounts ()
	local partitions = { "ux0:", "ur0:", "uma0:", "imc0:", "xmc0:" }

	for i=1,#partitions do
		if files.exists(partitions[i]) then
			local device_info = os.devinfo(partitions[i])
			if device_info then
				table.insert(PMounts,partitions[i])
			end
		end
	end
end
check_mounts ()
