--[[ 
	ONEMenu
	Application, themes and files manager.
	
	Licensed by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	Designed By Gdljjrod & DevDavisNunez.
	Collaborators: BaltazaR4 & Wzjk.
]]

--[[ 
	Particles FX library.
	Draw a shower of particles.
	
	Licensed by GNU General Public License v3.0
	
	Designed By:
	- DevDavisNunez (https://twitter.com/DevDavisNunez).
	
]]

stars = {math={}} -- module stars! :D

function stars.init(c)
	math.randomseed(os.clock())
	--stars.obj = image.new(3,3,c or color.new(255,255,255))
	stars.color = c or color.new(255,255,255)
	for i=1,100 do
		stars.math[i] = {x=math.random(0,960), y=math.random(0,544), s=(math.random(0,3)+math.random(0,2)), a=math.random(0,255)}
	end
end

function stars.render()
	for i=1,100 do
		stars.math[i].y+=stars.math[i].s
		stars.math[i].a-=1
		if stars.math[i].y>=544 then
			stars.math[i].x=math.random(0,960)
			stars.math[i].y=0
		end
		if stars.math[i].a<=0 then
			stars.math[i].a=255
		end
		--stars.obj:blit(stars.math[i].x, stars.math[i].y,stars.math[i].a)
		draw.circle(stars.math[i].x, stars.math[i].y, 3, stars.color:a(stars.math[i].a))
	end
end

stars.init(color.white)
