-- Loading language file
files.mkdir("ux0:data/AUTOPLUGIN2/lang/")
LANGUAGE = {}

function update_language(table_lang)
	if not table_lang then table_lang = {} end
	for k,v in pairs(table_lang) do
		LANGUAGE[k] = v
	end
end

function load_language(slang,mode)

	if 		slang == "JAPANESE" 		then if mode then update_language(JAPANESE) 		else update_language(CUSTOM_JAPANESE) end
	elseif 	slang == "ENGLISH_US"		then if not mode then update_language(CUSTOM_ENGLISH_US) end
	elseif 	slang == "FRENCH"			then if mode then update_language(FRENCH) 			else update_language(CUSTOM_FRENCH) end
	elseif 	slang == "SPANISH"			then if mode then update_language(SPANISH) 			else update_language(CUSTOM_SPANISH) end
	elseif 	slang == "GERMAN" 			then if mode then update_language(GERMAN) 			else update_language(CUSTOM_GERMAN) end
	elseif 	slang == "ITALIAN" 			then if mode then update_language(ITALIAN) 			else update_language(CUSTOM_ITALIAN) end
	elseif 	slang == "DUTCH" 			then if mode then update_language(DUTCH)			else update_language(CUSTOM_DUTCH) end
	elseif 	slang == "PORTUGUESE"		then if mode then update_language(PORTUGUESE)		else update_language(CUSTOM_PORTUGUESE)	end
	elseif 	slang == "RUSSIAN" 			then if mode then update_language(RUSSIAN)			else update_language(CUSTOM_RUSSIAN) end
	elseif 	slang == "KOREAN"			then if mode then update_language(KOREAN)			else update_language(CUSTOM_KOREAN) end
	elseif 	slang == "CHINESE_S"		then if mode then update_language(CHINESE_S)		else update_language(CUSTOM_CHINESE_S) end
	elseif 	slang == "CHINESE_T" 		then if mode then update_language(CHINESE_T)		else update_language(CUSTOM_CHINESE_T) end
	elseif 	slang == "FINNISH"			then if mode then update_language(FINNISH)			else update_language(CUSTOM_FINNISH) end
	elseif 	slang == "SWEDISH"			then if mode then update_language(SWEDISH)			else update_language(CUSTOM_SWEDISH) end
	elseif 	slang == "NORWEGIAN"		then if mode then update_language(NORWEGIAN)		else update_language(CUSTOM_NORWEGIAN) end
	elseif 	slang == "POLISH" 			then if mode then update_language(POLISH)			else update_language(CUSTOM_POLISH) end
	elseif 	slang == "PORTUGUESE_BR"	then if mode then update_language(PORTUGUESE_BR)	else update_language(CUSTOM_PORTUGUESE_BR) end
	elseif 	slang == "ENGLISH_GB"		then if mode then update_language(ENGLISH_GB)		else update_language(CUSTOM_ENGLISH_GB) end
	elseif 	slang == "TURKISH"			then if mode then update_language(TURKISH)			else update_language(CUSTOM_TURKISH) end
	end

end

function load_translates()

	LANGUAGE = {}

	dofile("lang/ENGLISH_US.lua")
	update_language(ENGLISH_US)

	-- Official Translations
	if files.exists("lang/"..__LANG..".lua") then
		dofile("lang/"..__LANG..".lua")
		load_language(__LANG, true)
	end

	-- User Translations
	if files.exists("ux0:data/AUTOPLUGIN2/lang/"..__LANG..".lua") then
		dofile("ux0:data/AUTOPLUGIN2/lang/"..__LANG..".lua")
		load_language(__LANG)
	end
end

load_translates()
