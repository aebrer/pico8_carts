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
  pxl.x += cx-3
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  
  if c == 7 then
   circ(x,y,1,burn(c))
  -- elseif c == 5 then
  --  circfill(x,y,2,burn(c))
  -- elseif c == 2 then
  --  circfill(x,y,2,burn(c))
  else
   -- line(x+3,y,x-3,y,burn(c))
   line(x,y-2,x,y+6,burn(c))

   -- line(x+3,y-3,x-3,y+3,burn(c))
   -- line(x-3,y-3,x+3,y+3,burn(c))
  end
 end
end


function drw_halo(x,y,rad,a,c)
 local shrink = 0.9
 local shirnk_fac = 0.05
 local points = {}
 for i=360,0,-18 do
  local tpx = cos(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  local tpy = sin(i/360.0) * rad --+ (rnd(1)*rnd_sign())
  add(points, {(flr(tpx)+x)*shrink,(flr(tpy)+y)*shrink})
  shrink -= shirnk_fac
 end

 local ready = false
 for i=#points,2,-1 do
  local pt_i = points[i]
  local pt_im1 = points[i-1]
  pt_i = rotate(a,x,y,pt_i[1],pt_i[2])
  pt_i = rotate(a,x,y,pt_i[1],pt_i[2])

  pt_im1 = rotate(-a,x,y,pt_im1[1],pt_im1[2])
  -- pt_im1 = rotate(a,x,y,pt_im1[1],pt_im1[2])

  if ready then
  line(pt_i[1], pt_i[2], pt_im1[1], pt_im1[2], c)
  -- line(-pt_i[1], -pt_i[2], -pt_im1[1], -pt_im1[2], c)
  -- line(pt_i[1], -pt_i[2], pt_im1[1], -pt_im1[2], c)
  -- line(-pt_i[1], pt_i[2], -pt_im1[1], pt_im1[2], c)

  -- pset(pt_i[1], pt_i[2],c)
  end
  ready = true
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
 0, -8, 8, -8, 8, 0, 8, 0
}
-- cls(colors[#colors])
pal(colors,1)

loop_l = 10
loop_counter = 0
oa_zero = false
loop_started = false
loop_ended = false


-- the actual drawing loop
::_::

 -- cls()

 --outer angle for overall rotation
 local oa = (t())%(loop_l/2)/(loop_l/2)
 oa -= 0.5
 local inner_rad = 40

 
 
 if oa <= 0.001 and not oa_zero then
  oa_zero = true
 end

 if oa > 0.001 and oa_zero then
  oa_zero = false
  loop_counter+=1
  srand(seed)
  -- cls()
 end  

 -- if oa <= 0.001 then
 --  srand(seed)
 -- end

  -- gif recording
 if loop_counter == 2 and not loop_started then
  extcmd("rec") -- start recording
  loop_started = true
 end
 if loop_counter == 4 and not loop_ended then
  extcmd("video") -- save video
  loop_ended = true
 end


 dither(0,0,300,1.0)
 dither(0,0,25,1.1)

 drw_halo(0,-8,inner_rad,oa,8)

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
