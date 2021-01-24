dofile("git/shared.lua")

if files.exists("ux0:/app/ONEUPDATE") then
	game.delete("ONEUPDATE") -- Exists delete update app
end

UPDATE_PORT = channel.new("UPDATE_PORT")

local scr_flip = screen.flip
function screen.flip()
	scr_flip()
	if UPDATE_PORT:available() > 0 then

		local info = UPDATE_PORT:pop()
		local version = info[1]
		local major = (version >> 0x18) & 0xFF;
		local minor = (version >> 0x10) & 0xFF;
		update = image.load("git/updater/update.png")

		if update then update:blit(0,0)
		elseif back then back:blit(0,0) end
		screen.flip()

		if os.dialog(info[2].."\n\n"..LANGUAGE["UPDATER_QUESTION_UPDATE"], APP_PROJECT.." v"..string.format("%X.%02X ",major, minor)..LANGUAGE["UPDATER_AVAILABLE"], __DIALOG_MODE_OK_CANCEL) == true then
			buttons.homepopup(0)

			if update then update:blit(0,0)
			elseif back then back:blit(0,0) end

			local url = "http://devdavisnunez.x10.mx/wikihb/download/?id=152"
			local path2vpk = "ux0:data/"..APP_PROJECT..".vpk"
			local onAppInstallOld = onAppInstall
			function onAppInstall(step, size_argv, written, file, totalsize, totalwritten)
				return 10 -- Ok code
			end
			local onNetGetFileOld = onNetGetFile
			function onNetGetFile(size,written,speed)

				if update then update:blit(0,0)
				elseif back then back:blit(0,0) end

				screen.print(10,10,LANGUAGE["UPDATER_DOWNLOADING"])
				screen.print(480,470,tostring(files.sizeformat(written or 0)).." / "..tostring(files.sizeformat(size or 0)),1,color.white, color.blue:a(135),__ACENTER)

				l = (written*940)/size
					screen.print(3+l,495,math.floor((written*100)/size).."%",0.8,0xFFFFFFFF,0x0,__ACENTER)
						draw.fillrect(10,524,l,6,color.new(0,255,0))
							draw.circle(10+l,526,6,color.new(0,255,0),30)

				screen.flip()

				buttons.read()
				--if buttons.cancel then return 0 end --Cancel or Abort
				return 1;
			end

			if http.download(url, path2vpk).success then
				os.delay(500)
				if files.exists(path2vpk) then
					files.mkdir("ux0:/data/1luapkg")
					files.copy("eboot.bin","ux0:/data/1luapkg")
					files.copy("git/updater/script.lua","ux0:/data/1luapkg/")
					files.copy("git/updater/update.png","ux0:/data/1luapkg/")
					files.copy("git/updater/language.lua","ux0:/data/1luapkg/")
					files.copy("git/updater/param.sfo","ux0:/data/1luapkg/sce_sys/")
					game.installdir("ux0:/data/1luapkg")
					files.delete("ux0:/data/1luapkg")
					game.launch(string.format("ONEUPDATE&%s&%s&%s&%s", os.titleid(), path2vpk, files.cdir().."/lang/", __LANG)) -- Goto installer extern!
				end
			end
			onAppInstall = onAppInstallOld
			onNetGetFile = onNetGetFileOld
			buttons.homepopup(1)
		end
	end
end

THID = thread.new("git/thread_net.lua")
