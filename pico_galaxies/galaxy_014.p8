pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
cls()
camera(-64,-64)
_set_fps(60)
--aebrer 2021


-- functions
function rnd_choice(itr)
 local i = flr(rnd(#itr)) + 1
 return(itr[i])
end

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


-- rotation function
-- og credit to @dec_hl on twitter
-- c := center for rotation
-- p := point to rotate
-- a := angle
function rotate(a,cx,cy,px,py)
 local x = px - cx
 local y = py - cy

 local xr = x*cos(a) - y*sin(a)
 local yr = y*cos(a) + x*sin(a)

 return {xr+cx, yr+cy}
end

function burn(c)
 local new_c = max(abs(c-1),1)
 return new_c
end

function rnd_sign()
 local coin_toss = rnd(1)
 local factor = 0.0
 if coin_toss >= 0.5 then
  factor = -1
 else
  factor = 1
 end
 return(factor)
end

function dither(cx,cy,loops,pull)

 for i=loops,1,-1 do 

  local pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * 0.5
  y = pxl.y * 0.5
  circ(x,y,oa*10,burn(c))

  pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  circfill(x,y,2,burn(c))


 end
end



function drw_halo(x,y,rad,a,c)
 local shrink = 0.9
 local shirnk_fac = 0.1
 local points = {}
 for i=360,0,72 do
  local tpx = cos(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  local tpy = sin(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  add(points, {(flr(tpx)+x)*shrink,(flr(tpy)+y)*shrink})
  shrink -= shirnk_fac
 end

 local ready = false
 for i=#points,1,-1 do
  local pt_i = points[i]
  pt_i = rotate(-a,x,y,pt_i[1],pt_i[2])
  pset(pt_i[1], pt_i[2], c)
  pset(-pt_i[1], -pt_i[2], c)
 end
 
end

function dotter()
 for x=64,-64,-1 do
  for y=64,-64,-1 do
   if x%2 == 0 or y%2 == 0 then
    pset(x,y,8)
   else
    if t()*1000 % 2 then
     local c = pget(x,y)
     pset(x,y,burn(c))
    else
     pset(x,y,0)
    end
   end
  end
 end
end


-- setting params
seed = flr(rnd(-1))
srand(seed)
seed_rst_needed = false
-- colors = {
--  0, -15, 1, -4, 1, 7, 12, 0
-- }

colors = {
 0, 12, -9, 1, -4, 13, -8, -15
}
-- cls(colors[#colors])
pal(colors,1)

loop_l = 8
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false

dither_rad = rnd(1.0) + 0.25
dither_amt = rnd(50) + 10
inner_rad = rnd(10) + 10


-- the actual drawing loop
::_::

 _set_fps(60)
 -- cls()

 --outer angle for overall rotation
 oa = (t())%(loop_l/2)/(loop_l/2)
 oa -= 0.5
 local inner_rad = 20

 
 
 if oa <= -0.49 and not oa_zero then
  oa_zero = true
 end

 if oa > -0.49 and oa_zero then
  oa_zero = false
  loop_counter+=1
  srand(seed)
  -- cls()
 end  

 -- if oa <= 0.001 then
 --  srand(seed)
 -- end
 
 drw_halo(0,0,inner_rad,oa,8)
 dither(0,0,dither_amt,dither_rad)
 dotter()

 pal(colors,1)
 -- flip()

 -- -- gif recording
 -- if loop_counter == 2 and not loop_started then
 --  extcmd("rec") -- start recording
 --  loop_started = true
 -- end
 -- if loop_counter == 4 and not loop_ended then
 --  extcmd("video") -- save video
 --  loop_ended = true
 -- end

goto _


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
