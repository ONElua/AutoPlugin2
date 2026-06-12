--[[
	## Library Scroll ##
	Designed By DevDavis (Davis Nuñez) 2011 - 2018.
	Based on library of Robert Galarga.
	Create a obj scroll, this is very usefull for list show

	Modified by gdljjrod 2019

]]

function newScroll(a,b,c)

	local obj = {ini=1,sel=1,lim=1,maxim=0,minim=0}

	function obj:set(tab,mxn,modemintomin) -- Set a obj scroll
		obj.ini,obj.sel,obj.lim,obj.maxim,obj.minim, obj.mxn = 1,1,1,1,1,mxn
		if(type(tab)=="number")then
			if tab > mxn then obj.lim=mxn else obj.lim=tab end
			obj.maxim = tab
		else
			if #tab > mxn then obj.lim=mxn else obj.lim=#tab end
			obj.maxim = #tab
		end
		if modemintomin then obj.minim = obj.lim end
	end

	function obj:max(mx)
		obj.maxim = #mx
	end

	function obj:up()
		if obj.sel>obj.ini then obj.sel=obj.sel-1 return true
		elseif obj.ini-1>=obj.minim then
			obj.ini,obj.sel,obj.lim=obj.ini-1,obj.sel-1,obj.lim-1
			return true
		end
	end

	function obj:down()
		if obj.sel<obj.lim then obj.sel=obj.sel+1 return true
		elseif obj.lim+1<=obj.maxim then
			obj.ini,obj.sel,obj.lim=obj.ini+1,obj.sel+1,obj.lim+1
			return true
		end
	end

	function obj:delete(tab)
		table.remove(tab,obj.sel)

		if obj.ini == 1 then
			if obj.sel == obj.maxim then obj.sel-=1 end
			if #tab > obj.mxn then obj.lim = obj.mxn else obj.lim = #tab end
		else
			if obj.sel == obj.maxim then
				obj.sel,obj.ini,obj.lim = obj.sel-1,obj.ini-1,obj.lim-1
			else
				if (#tab - obj.ini) + 1 < obj.mxn then obj.lim,obj.ini = obj.lim-1,obj.ini-1 end
			end
		end
		obj.maxim = #tab
	end

	if a and b then
		obj:set(a,b,c)
	end

	return obj

end
