pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
--aebrer 2021


-- functions

function rnd_pixel()
 local px_x = (
  flr(rnd(128))
 ) - 64
 local px_y = (
  flr(rnd(128))
 ) - 64
 local pixel = {
  x=px_x,
  y=px_y
 }
 return(pixel)
end

function burn(c)
 local new_c = max(abs(c-1),1)
 return new_c
end

function dither(cx,cy,loops,pull)

 for i=loops,1,-1 do 

  local pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  circ(pxl.x,pxl.y,1,burn(c))
 end
end

function drw_layer(bottom,y,a,fudge,c)
 for i=64,-64,-fudge do
  local k = i/32
  local j = i-64

  oval(
   j-20+(3*(cos(a)+sin((k+64+bottom)/128))),
   bottom+34,
   j+20,
   y+(5*(sin((k+64+bottom)/400))),
   c)
  ovalfill(
   i-20+(3*(cos(a)+sin((k+64+bottom)/128))),
   bottom+34,
   i+20,
   y+(5*(sin((k+64+bottom)/400))),
   c)

 end
end


-- setting params
seed = flr(rnd(-1))
srand(seed)
colors = {
 8, -15, 0, -15, 
 -4, 12, -15, 
 1, -15,
 8,-8,8,-7,-8,-4
}
pal(colors,1)
cls(1)

loop_l = 8
lc = 0
oa_zero = false
loop_started = false
loop_ended = false


-- the actual drawing loop
::_::

 -- timing the loop
 local oa = (t())%(loop_l/2)/(loop_l/2) 
 if oa <= 0.001 and not oa_zero then
  oa_zero = true
 end
 if oa > 0.001 and oa_zero then
  oa_zero = false
  lc+=1
  srand(seed)
  -- cls()
 end  

 -- gif recording
 if lc == 2 and not loop_started then
 extcmd("rec") -- start recording
 loop_started = true
 end
 if lc == 4 and not loop_ended then
 extcmd("video") -- save video
 loop_ended = true
 end

 -- drawing to the screen
 dither(0,0,200,1.0)
 for i=100,0,-1 do
  local p = rnd_pixel()
  c = 10+(flr(rnd(6))+1)
  circ(p.x,p.y,rnd(4),c)
  rectfill(
   p.x+rnd(2),
   p.y+rnd(2),
   p.x-rnd(2),
   p.y-rnd(2),
   c
  )
 end
 dither(0,0,200,0.3)
 rectfill(25,25,40,-32,0)
 drw_layer(-5,0,oa,16,2)
 drw_layer(-7,-5,oa,6,3)
 drw_layer(0,-3,oa,19,4)
 drw_layer(5,0,oa,14,5)
 drw_layer(15,10,oa,12,6)
 drw_layer(32,15,oa,9,7)
 drw_layer(40,30,oa,18,8)
 drw_layer(64,35,oa,25,9)

 pal(colors,1)
 flip()

goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
