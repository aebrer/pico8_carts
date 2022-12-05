pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
r=rnd
s=r(-1)srand(s)cls()poke(0x5f54,0x60)
_set_fps(60)
kiosk=true
menuitem(1,"kiosk mode",function()flip()kiosk=(not kiosk)end)

function move_screen(d)
 sx=r(128)
 sy=r(128)
	if d==⬅️ then
	 sspr(0,0,1,128,127,0,1,128)
  for sx=1,127 do
  	sspr(sx,0,1,128,sx-1,0,1,128)
  end
	elseif d==➡️ then	
  sspr(127,0,1,128,0,0,1,128)
  for sx=126,0,-1 do
  	sspr(sx,0,1,128,sx+1,0,1,128)
  end
	elseif d==⬆️ then
  sspr(0,0,128,1,0,127,128,1)
  for sy=1,127 do
  	sspr(0,sy,128,1,0,sy-1,128,1)
  end	
	elseif d==⬇️ then	
  sspr(0,127,128,1,0,0,128,1)
  for sy=126,0,-1 do
  	sspr(0,sy,128,1,0,sy+1,128,1)
  end
 end
end

xf1=0
xf2=0
yf1=0
yf2=0

function get_pal()
	for i=0,15 do
		pal(i,r(32)-16,1)
	end
end

get_pal()

function setup()
	-- setup random noise as base
	for x=0,127,1 do
		for y=0,127,1 do
			pset(x,y,r(16))
		end
		flip()
	end
	xf1=r({1,2,3,5,7})
	xf2=r({1,2,3,5,7})
	yf1=r({1,2,3,5,7})
	yf2=r({1,2,3,5,7})
 s+=1
end

setup()
x,y=0,0

::_::


for i=0,200 do
 if(r()>.99 and r()>.9)srand(s)
 x+=r({1,2,3,5,7,11})x%=128
	y+=r({1,2,3,5,7,11})y%=128
	c=pget(x,y)
	nx=0ny=0nc=0nd=0  -- best neighbor 
	for j in all({-xf1,xf2}) do
		for k in all({-yf1,yf2}) do
			--neighbor colors
			tx=(x+j)%128
			ty=(y+k)%128
			tc=pget(tx,ty)
			diff = abs(tc-c)
			if(r(diff)>nd)nd=diff;nx=tx;ny=ty;nc=tc
		end
	end
 pset(nx,ny,c)
end

flip()
if(btnp(❎))setup()kiosk=false
if(btnp(🅾️))get_pal()kiosk=false

if(btn(⬅️))move_screen(⬅️)kiosk=false
if(btn(➡️))move_screen(➡️)kiosk=false
if(btn(⬆️))move_screen(⬆️)kiosk=false
if(btn(⬇️))move_screen(⬇️)kiosk=false

if kiosk then
	if(t()%60==0)get_pal()setup()
end

goto _

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
