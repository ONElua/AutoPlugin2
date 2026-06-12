--[[
	## Library Wave ##
	Designed By DevDavis (Davis Nuñez) 2015 - 2016.
	Based on library of Nekerafa.
	Create a obj Wave, this is very usefull for more custom graphics
	]]
function newWave()
	local obj = {x=0,y=0,a=255,img=nil}
	function obj:begin(path)
		obj.img = image.load(path)
--obj.img:flipv()
		return obj.img != nil
	end
	function obj:finalize(path)
		-- obj.img:free()
		obj.img = nil
	end
	function obj:xy(x,y)
		obj.x = (x or obj.x)
		obj.y = (y or obj.y)
	end
	function obj:alfa(a)
		if a then obj.a = a end
		if obj.a > 255 then obj.a = 255 end
		if obj.a < 0 then obj.a = 0 end
		return obj.a
	end
	function obj:state()
		return obj.img != nil
	end
	function obj:blit(v,a)
		if obj.img then
			obj.img:flipv()
			if obj.x < 0 then obj.x = obj.x + 960 end
			obj.x += (v or 2)
			-- Medidas Empieza a dibujar en el 111px y mide 161 lo sobrante, pero restamos el size de la barra inferior, resulta 137
			obj.img:blit(obj.x, obj.y, 0, 0, 960-obj.x, 544, (a or obj.a))  --obj.img:blit(obj.x, obj.y) --obj.img:blit(obj.x-480, obj.y)
			obj.img:blit(obj.x-960, obj.y, 0, 0, 960, 544, (a or obj.a))  
			if obj.x >= 960 then obj.x = 0 end
		end
	end
	return obj
end
